//
//  OnboardingViewModel.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 05.12.2024.
//

import SwiftUI
import StoreKit
struct OnboardingStep {
    let imageName: String
    let title: String
    let description: String
}

class OnboardingViewModel: ObservableObject {
    @Published var currentIndex = 0 {
        willSet {
            if newValue == 1 {
                requestAppStoreReview()
            }
        }
    }
    @Published var showCloseButton = false
    @Published var showRequestReviewView = false
    @Published var showContentView = false
    @Published var pagesCount: Int = 4
    @Published var afterReview = false
    @Published var opacityLevel: Double = 0
    @Published var remoteTimer = 0
    @Environment(\.requestReview) var requestReview

    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    let onboardingData = [
        OnboardingStep(
            imageName: "onboarding_1",
            title: "Welcome to\nPDF Converter",
            description: "It's a powerful tool for working with PDF\nDigitize your documents in a blink with app"
        ),
        OnboardingStep(
            imageName: "onboarding_2",
            title: "Unleash the power\nof PDF Scanner usage",
            description: "It's magical tool in your pocket that\ncan transform all your files into PDF"
        ),
        OnboardingStep(
            imageName: "onboarding_3",
            title: "Try to merge\nyour files to PDF",
            description: "It's magical tool in your pocket that\ncan transform all your files into PDF"
        )
    ]
    
    func closeOnboarding() {
        isOnboarding = false
    }
    
    
    func setPageCounter() {
        afterReview = true
        pagesCount = onboardingData.count + 1
    }
    
    func nextStep() {
        if currentIndex < onboardingData.count - 1 {
            currentIndex += 1
        }
    }
    
    func requestAppStoreReview() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
}
