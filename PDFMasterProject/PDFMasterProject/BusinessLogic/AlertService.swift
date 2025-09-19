//
//  AlertService.swift
//  PDFMaster
//
//  Created by George Popkich on 31.01.25.
//

import SwiftUI

final class AlertService: ObservableObject {
    struct AlertItem: Identifiable {
        let id = UUID()
        let title: String
        let message: String?
        let primaryButton: Alert.Button?
        let secondaryButton: Alert.Button?
    }
    
    static let instance: AlertService = .init()

    private init() {}
    
    @Published var alertItem: AlertItem?

    func showAlert(title: String,
                   message: String? = nil,
                   cancelTitle: String? = nil,
                   cancelHandler: (() -> Void)? = nil,
                   okTitle: String? = nil,
                   okHandler: (() -> Void)? = nil,
                   settingTitle: String? = nil,
                   settingHandler: (() -> Void)? = nil,
                   deleteTitle: String? = nil,
                   deleteHandler: (() -> Void)? = nil) {
        
        var primaryButton: Alert.Button?
        var secondaryButton: Alert.Button?
        
        if let okTitle {
            primaryButton = .default(Text(okTitle), action: okHandler)
        }
        
        if let cancelTitle {
            secondaryButton = .cancel(Text(cancelTitle), action: cancelHandler)
        }
        
        if let settingTitle {
            primaryButton = .default(Text(settingTitle), action: settingHandler)
            secondaryButton = .cancel(Text("Cancel"))
        }
        
        if let deleteTitle {
            primaryButton = .destructive(Text(deleteTitle), action: deleteHandler)
            secondaryButton = .cancel(Text("Cancel"))
        }
        
        alertItem = AlertItem(
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton
        )
    }
}

