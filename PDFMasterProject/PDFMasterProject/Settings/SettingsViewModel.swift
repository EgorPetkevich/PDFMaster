//
//  SettingsViewModel.swift
//  PDFMaster
//
//  Created by George Popkich on 30.01.25.
//

import StoreKit
import SwiftUI
import MessageUI

@MainActor final class SettingsViewModel: ObservableObject {
    private var alertService: AlertService = .instance
    private var apphudService: ApphudService = .instance
    
    @Published var settingsOptions = SettingsOptions.Settings.allCases
    
    @Published var isSharing = false
    @Published var showMailView = false
    @Published var showPaywall = false


    func rowDidSelect(_ row: SettingsOptions.Settings) {
        switch row {
        case .rate: rateUsDidSelect()
        case .contact: contactUsDidSelect()
        case .terms: termsDidSelect()
        case .privacy: privacyDidSelect()
        case .share: shareDidSelect()
        }
    }
    
    init() {}
    
    func showReviewPaywall() -> Bool {
        UDManager.getValue(forKey: .isReview)
    }
    
}

// MARK: - Settings Handlers
extension SettingsViewModel {
    private func rateUsDidSelect() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }

    private func contactUsDidSelect() {
        if MFMailComposeViewController.canSendMail() {
            showMailView = true
        } else {
            self.alertService.showAlert(title: "Error", okTitle: "Ok")
        }
    }
    
    private func termsDidSelect() {
        if let url = URL(string: AppConfig.terms) {
            UIApplication.shared.open(url)
        }
    }

    private func privacyDidSelect() {
        if let url = URL(string: AppConfig.privacy) {
            UIApplication.shared.open(url)
        }
    }

    private func shareDidSelect() {
        ShareControllerManager.share(activityItems: AppConfig.share)
    }
    
   
}


