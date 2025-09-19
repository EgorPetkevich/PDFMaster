//
//  Image+Const.swift
//  PDFMaster
//
//  Created by George Popkich on 30.01.25.
//

import SwiftUI


extension Image {
    
    enum Settings {
        static let pdf: Image = Image("settings_pdf")
        static let rateUs: Image = Image("settings_star")
        static let contactUs: Image = Image("settings_message")
        static let termsOfUse: Image = Image("settings_terms")
        static let privacyPolicy: Image = Image("settings_privacy")
        static let shareApp: Image = Image("settings_share")
        
    }
    
    enum Onboarding {
        
    }
    
    enum ImageConverter {
        static let completeIcon: Image = Image("imageConverter_complete_icon")
    }
    
    enum Paywall {
        static let reviewBack: Image = Image("onboarding_4")
        static let cross: Image = Image("cross")
    }
    
    
}
