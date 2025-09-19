//
//  SettingsOptions.swift
//  PDFMaster
//
//  Created by George Popkich on 30.01.25.
//

import SwiftUI

struct SettingsOptions {
    
    enum Settings: CaseIterable, Hashable {
        case rate
        case contact
        case terms
        case privacy
        case share
        
        var title: String {
            switch self {
            case .rate: return "Rate us"
            case .contact: return "Contact us"
            case .terms: return "Terms of Use"
            case .privacy: return "Privacy policy"
            case .share: return "Share app"
            }
        }
        
        var icon: Image {
            switch self {
            case .rate: return Image.Settings.rateUs
            case .contact: return Image.Settings.contactUs
            case .terms: return Image.Settings.termsOfUse
            case .privacy: return Image.Settings.privacyPolicy
            case .share: return Image.Settings.shareApp
            }
        }
    }
}
