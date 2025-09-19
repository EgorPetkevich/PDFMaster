//
//  ShareControllerManager.swift
//  PDFMaster
//
//  Created by George Popkich on 1.02.25.
//

import UIKit

final class ShareControllerManager {
    
    static func share(activityItems: Any...) {
        let activityVC = UIActivityViewController(
            activityItems: [activityItems],
            applicationActivities: nil)
        if 
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController
        {
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }
    
}
