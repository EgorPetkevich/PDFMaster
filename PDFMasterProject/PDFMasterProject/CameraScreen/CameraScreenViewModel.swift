//
//  CameraScreenViewModel.swift
//  PDFMaster
//
//  Created by George Popkich on 6.02.25.
//

import Foundation
import UIKit

final class CameraScreenViewModel: ObservableObject {
    
    private var alertService: AlertService = .instance
    @Published var flashMode: Bool = false
    @Published var images: [UIImage] = []
    
    private var cameraManager = CameraManager()
    
    init() {
        setup()
        setupObservers()
    }
    
    private func setup() {
        cameraManager.onCameraError = { _ in self.onCameraError() }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc private func viewWillResignActive() {
        cameraManager.toggleTorch(true) { [weak self] flashMode in
            self?.flashMode = flashMode
        }
      }
    
}

//MARK: - CameraScreenView Handlers
extension CameraScreenViewModel {
    
    func onCameraError() {
        DispatchQueue.main.async { [weak self] in
            self?.alertService.showAlert(
                title: "Camera Error",
                message: "You need to allow your camera to perform scans.",
                settingTitle: "Go to Settings",
                settingHandler: {
                    if let appSettings =
                        URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings,
                                                  options: [:],
                                                  completionHandler: nil)
                    }
                })
        }
    }
    
    func getCameraManager() -> CameraManager {
        self.cameraManager
    }
    
    func switchCamera() {
        cameraManager.toggleTorch(true) { [weak self] flashMode in
            self?.flashMode = flashMode
        }
        cameraManager.switchCamera()
    }
    
    func toggleTorch() {
        cameraManager.toggleTorch(flashMode) { [weak self] flashStatus in
            self?.flashMode = flashStatus
        }
    }
    
    func capturePhoto(_ photoCompletion: @escaping (UIImage) -> Void) {
        cameraManager.capturePhoto(photoCompletion)
    }
    
}
