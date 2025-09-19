
//
//  AppConfiguration.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 04.12.2024.
//

import Foundation
import ApphudSDK
import FirebaseRemoteConfig

enum AppMode {
    case faceControl
    case warrior
}

enum PaywallType {
    case paywall1FaceControl
    case paywall2Warrior
    case paywall3FaceControl
    case paywall4Warrior
    case specialOffer
}

struct AppConfiguration {
    static let shared = AppConfiguration()
    
    private let remoteConfig = RemoteConfigManager.shared
    
    var mode: AppMode {
        remoteConfig.getBoolValue(forKey: "isWarriorMode") ? .warrior : .faceControl
    }
    
    var shouldShowReviewRequest: Bool {
        remoteConfig.getBoolValue(forKey: "showReviewRequest")
    }
    
    var subtitleOpacity: Double {
        mode == .warrior ? 0.5 : 1.0
    }
    
    var paywallCloseButtonDelay: TimeInterval {
        mode == .warrior ? 5.0 : 0.0
    }
    
    var showPageControlOnPaywall: Bool {
        remoteConfig.getBoolValue(forKey: "showPageControlOnPaywall")
    }
    
    var extraPageIndicator: Bool {
        remoteConfig.getBoolValue(forKey: "extraPageIndicator")
    }
    
    func getPaywallType(afterOnboarding: Bool, userExitedTwice: Bool) -> PaywallType {
        if userExitedTwice {
            return .specialOffer
        }
        
        switch mode {
        case .warrior:
            return afterOnboarding ? .paywall2Warrior : .paywall4Warrior
        case .faceControl:
            return afterOnboarding ? .paywall1FaceControl : .paywall3FaceControl
        }
    }
}
