//
//  ApphudService.swift
//  PDFMaster
//
//  Created by George Popkich on 1.02.25.
//

import Foundation
import ApphudSDK
import StoreKit
import SwiftUI

@MainActor
final class ApphudService: ObservableObject {
    
    enum PurchaseType: Int {
        case weekly
        case trial
        
        var productId: String {
            switch self {
            case .weekly: return "com.files.converter.app.weekly"
            case .trial: return "com.files.converter.app.weekly.trial"
            }
        }
    }
    
    static let instance = ApphudService()
    
    @Published var paywallView: AnyView? = nil
    @Published var paywallWasShown: Bool = false
    
    @Published var paywall: ApphudPaywall?
    @Published var remoteConfig: SubRemoteConfig?
    @Published var products: [ApphudProduct]? {
        didSet {
            guard oldValue != products else { return }
            updateProductPrices()
        }
    }
    
    @Published var isPremium: Bool = /*Apphud.hasActiveSubscription()*/true
    @Published var productTrialPrice: String?
    @Published var productWeeklyPrice: String?
    
    private init() {
//        Task {
//            await loadPaywall()
//        }
    }
}

// MARK: - Public Methods
extension ApphudService {
    
    enum RemoteConfigError: Error {
        case failedToFetch
    }

    func getRemoteConfig() async throws -> SubRemoteConfig {
        
        guard let config =  await fetchRemoteConfig() else {
           
            throw NSError(domain: "RemoteConfig", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка загрузки конфига"])
        }
        UDManager.setTimerValue(Int(config.paywallCloseDelay))
        return config
    }
    
    private func loadPaywall() async {
        do {
            let config = try await getRemoteConfig()
            DispatchQueue.main.async {
                UDManager.setValue(forKey: .isReview, value: config.isReview)
                if config.isReview {
                    self.paywallView = AnyView(ReviewPaywallView(viewModel: ReviewPaywallViewModel {
                        self.paywallWasShown = true
                        self.paywallView = nil
                    }))
                } else {
                    self.paywallView = AnyView(ProdPaywallView(viewModel: ProdPaywallViewModel {
                        self.paywallWasShown = true
                        self.paywallView = nil
                    }, showPageContorl: false))
                }
            }
        } catch {
            print("[Error] Load Paywall: \(error)")
        }
    }
    
    func checkStatus() -> Bool {
        return true
//        return Apphud.hasActiveSubscription()
    }

    func getProductPrice(type: PurchaseType) -> String? {
        guard let product = products?.first(where: { $0.productId == type.productId }) else {
            print("[ERROR] Product with ID \(type.productId) not found.")
            return nil
        }
        
        guard let skProduct = product.skProduct else {
            print("[ERROR] skProduct is nil for product ID \(type.productId).")
            return nil
        }
        return skProduct.localizedCurrencyPrice
    }
    
    func makePurchase(type: PurchaseType) async -> Bool {
        print("\(type.productId)")
        guard let product = products?.first(where: { $0.productId == type.productId }) else {
            print("[ERROR] Product not found for \(type.productId)")
            return false
        }
        
        let result = await withCheckedContinuation { continuation in
            Apphud.purchase(product) { result in
                if let subscription = result.subscription, subscription.isActive() {
                    print("Subscription active for \(type.productId)")
                    continuation.resume(returning: true)
                } else if let nonRenewingPurchase = result.nonRenewingPurchase, nonRenewingPurchase.isActive() {
                    print("Non-renewing purchase active for \(type.productId)")
                    continuation.resume(returning: true)
                } else if let error = result.error {
                    print("[ERROR] Purchase failed: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                } else {
                    print("[ERROR] Unknown purchase state for \(type.productId)")
                    continuation.resume(returning: false)
                }
            }
        }
        
        isPremium = result
        return result
    }

    func restorePurchases() async -> Bool {
        let result = await withCheckedContinuation { continuation in
            Apphud.restorePurchases { [weak self] subscriptions, _, error in
                if let error = error {
                    print("[RESTORE FAILURE]: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                    return
                }
                
                let isPremium = subscriptions?.contains(where: { $0.isActive() }) ?? false
                self?.isPremium = isPremium
                print("[RESTORE SUCCESS]: Access \(isPremium ? "restored" : "not restored")")
                continuation.resume(returning: isPremium)
            }
        }
        return result
    }
}

// MARK: - Private Methods
extension ApphudService {
    
    private func fetchRemoteConfig() async -> SubRemoteConfig? {
        if let paywall = paywall {
            return decodeRemoteConfig(from: paywall)
        } else {
            let fetchedPaywall = await fetchPaywall()
            self.paywall = fetchedPaywall
            return decodeRemoteConfig(from: fetchedPaywall)
        }
    }
    
    private func fetchPaywall() async -> ApphudPaywall? {
        await withCheckedContinuation { continuation in
            Apphud.paywallsDidLoadCallback { paywalls, error in
                if let paywall = paywalls.first(where: { $0.identifier == "onboarding_paywall" }) {
                    continuation.resume(returning: paywall)
                } else {
                    print("[ERROR] Paywall not found")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func decodeRemoteConfig(from paywall: ApphudPaywall?) -> SubRemoteConfig? {
        guard let json = paywall?.json else { return nil }

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let config = try JSONDecoder().decode(SubRemoteConfig.self, from: data)
            return config
        } catch {
            print("[ERROR] Failed to decode remote config: \(error)")
            return nil
        }
    }
    
    private func fetchProducts() async {
        if let paywall = paywall {
            products = paywall.products
        } else {
            let fetchedPaywall = await fetchPaywall()
            self.paywall = fetchedPaywall
            self.products = fetchedPaywall?.products
        }
    }
    
    private func updateProductPrices() {
        productTrialPrice = getProductPrice(type: .trial)
        productWeeklyPrice = getProductPrice(type: .weekly)
    }
}
