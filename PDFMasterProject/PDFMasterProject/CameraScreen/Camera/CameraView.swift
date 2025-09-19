//
//  CameraView.swift
//  PDFMaster
//
//  Created by George Popkich on 6.02.25.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    let cameraManager: CameraManager
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let previewLayer = cameraManager.createPreviewLayer()
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = viewController.view.bounds
        
        if let previewLayer = previewLayer {
            viewController.view.layer.addSublayer(previewLayer)
        }
        
        cameraManager.checkPermissionAndStartSession()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

