//
//  ReviewPaywallViewModel.swift
//  PDFMaster
//
//  Created by George Popkich on 4.02.25.
//

import SwiftUI

final class ReviewPaywallViewModel: ObservableObject {
    private var coordinator: ReviewPaywallCoordinator = .init()
    
    private var alertService: AlertService = .instance
    private var apphudService: ApphudService = .instance
    
    @Published var dismissView: Bool = false
    @Published var showCrossButton: Bool = false
    
    @Published var trialDidSelect: Bool = false
    
    var onDismiss: (() -> Void)?
    
    @Published var weeklyPrice: String = ""
    @Published var trialPrice: String = ""
    
    private var timer: Timer = Timer()
    
    init(_ onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
        commonInit()
    }
    
    private func commonInit() {
        Task {
            await updatePrices()
        }
        startTimer()
    }
    
    deinit {
        timer.invalidate()
    }
    
}

// MARK: - ReviewVC Handlers
extension ReviewPaywallViewModel {
    
    func crossButtonDidTap() {
        self.dismissView = true
        self.onDismiss?()
    }
    
    func restorButtonDidTap() async {
        onPurchaseResult(await apphudService.restorePurchases())
    }
    
    func switchToggle(_ state: Bool) {
        trialDidSelect = state
    }
    
    func subButtonDidTap() async {
        if self.trialDidSelect {
            onPurchaseResult(
                await self.apphudService.makePurchase(type: .trial))
        } else {
            onPurchaseResult(
                await self.apphudService.makePurchase(type: .weekly))
        }
        
    }
    
    func termsDidTap() {
        if let url = URL(string: AppConfig.terms) {
            UIApplication.shared.open(url)
        }
    }
    
    func privacyDidTap() {
        if let url = URL(string: AppConfig.privacy) {
            UIApplication.shared.open(url)
        }
    }
   
}

//MARK: - ReviewPaywall Handler
extension ReviewPaywallViewModel {
    
    private func updatePrices() async {
        if let weeklyPrice = await apphudService.getProductPrice(type: .weekly) {
            self.weeklyPrice = weeklyPrice
        }
        
        if let trialPrice =  await apphudService.getProductPrice(type: .trial) {
            self.trialPrice = trialPrice
        }
    
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(UDManager.getTimerValue()),
            repeats: false,
            block: { [weak self] timer in
                self?.showCrossButton = true
        })
    }
    
    private func onPurchaseResult(_ result: Bool) {
        DispatchQueue.main.async {
            if result {
                self.dismissView = true
            } else {
                self.showErrorAlert()
            }
        }
    }
    
    private func showErrorAlert() {
        alertService.showAlert(title: "Oops...",
                               message: "Something went wrong. Please try again",
                               cancelTitle: "Cancel", 
                               okTitle: "Try again", 
                               okHandler: { 
            Task {
                await self.subButtonDidTap()
            }
        })
    }
    
}
