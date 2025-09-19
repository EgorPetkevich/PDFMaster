//
//  RemouteConfig.swift
//  PDFMaster
//
//  Created by George Popkich on 1.02.25.
//

import Foundation

struct SubRemoteConfig: Codable {
    let onboardingCloseDelay: Double
    let paywallCloseDelay: Double
    let onboardingButtonTitle: String?
    let paywallButtonTitle: String?
    let onboardingSubtitleAlpha: Double
    let isPagingEnabled: Bool
    let isReviewEnabled: Bool
    let isReview: Bool

    private enum CodingKeys: String, CodingKey {
        case onboardingCloseDelay = "onboarding_close_delay"
        case paywallCloseDelay = "paywall_close_delay"
        case onboardingButtonTitle = "onboarding_button_title"
        case paywallButtonTitle = "paywall_button_title"
        case onboardingSubtitleAlpha = "onboarding_subtitle_alpha"
        case isPagingEnabled = "is_paging_enabled"
        case isReviewEnabled = "is_review_enabled"
        case isReview = "is_review"
    }
}
