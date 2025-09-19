//
//  CameraManager.swift
//  PDFMaster
//
//  Created by George Popkich on 6.02.25.
//

import SwiftUI
import AVFoundation

// 
//class CameraManager: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
//    private let session = AVCaptureSession()
//    private let metadataOutput = AVCaptureMetadataOutput()
//    private let cameraDevice = AVCaptureDevice.default(for: .video)
//    
//    var onCodeScanned: ((String) -> Void)?
//    var onCameraError: ((String) -> Void)?
//    var qrNotFoundError: ((String) -> Void)?
//    var playLoadAnimation: ((Bool) -> Void)?
//    
//    override init() {
//        super.init()
//        configureVideoInput()
//        configureMetadataOutput()
//    }
//    
//    func createPreviewLayer() -> AVCaptureVideoPreviewLayer? {
//        return AVCaptureVideoPreviewLayer(session: session)
//    }
//    
//    func checkPermissionAndStartSession() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            startSession()
//        case .notDetermined:
//            requestCameraAccess()
//        default:
//            onCameraError?("Camera access denied. Please enable it in Settings.")
//        }
//    }
//    
//    private func requestCameraAccess() {
//        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
//            DispatchQueue.main.async {
//                if granted {
//                    self?.startSession()
//                } else {
//                    self?.onCameraError?("Camera access denied. Please enable it in Settings.")
//                }
//            }
//        }
//    }
//    
//    private func startSession() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.session.startRunning()
//        }
//    }
//    
//    func stopSession() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.session.stopRunning()
//        }
//    }
//    
//    func switchCamera() {
//        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else {
//            onCameraError?("No camera input found.")
//            return
//        }
//        
//        let newPosition: AVCaptureDevice.Position = (currentInput.device.position == .back) ? .front : .back
//        
//        guard let newCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else {
//            onCameraError?("No available camera for selected position.")
//            return
//        }
//        
//        do {
//            let newVideoInput = try AVCaptureDeviceInput(device: newCameraDevice)
//            session.beginConfiguration()
//            
//            session.removeInput(currentInput)
//            if session.canAddInput(newVideoInput) {
//                session.addInput(newVideoInput)
//            } else {
//                session.addInput(currentInput) // Возвращаем старый, если не удалось добавить новый
//            }
//            
//            session.commitConfiguration()
//        } catch {
//            onCameraError?("Error switching camera: \(error.localizedDescription)")
//        }
//    }
//
//    
//    private func configureVideoInput() {
//        guard let cameraDevice = cameraDevice else {
//            onCameraError?("Camera not available.")
//            return
//        }
//        
//        do {
//            let videoInput = try AVCaptureDeviceInput(device: cameraDevice)
//            if session.canAddInput(videoInput) {
//                session.addInput(videoInput)
//            } else {
//                onCameraError?("Unable to add video input.")
//            }
//        } catch {
//            onCameraError?("Error setting up video input: \(error)")
//        }
//    }
//    
//    private func configureMetadataOutput() {
//        if session.canAddOutput(metadataOutput) {
//            session.addOutput(metadataOutput)
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .code128]
//        } else {
//            onCameraError?("Unable to add metadata output.")
//        }
//    }
//    
//    func toggleTorch(_ isEnabled: Bool, flashMode: ((Bool) -> Void)?) {
//        guard let cameraDevice = cameraDevice, cameraDevice.hasTorch else {
//            onCameraError?("Flash not available.")
//            return
//        }
//        
//        do {
//            try cameraDevice.lockForConfiguration()
//            cameraDevice.torchMode = isEnabled ? .off : .on
//            flashMode?(!isEnabled)
//            cameraDevice.unlockForConfiguration()
//        } catch {
//            onCameraError?("Error toggling flash: \(error)")
//        }
//    }
//    
//    // MARK: - AVCaptureMetadataOutputObjectsDelegate
//    
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        playLoadAnimation?(true)
//        stopSession()
//        
//        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
//              let code = metadataObject.stringValue else {
//            playLoadAnimation?(false)
//            qrNotFoundError?("No QR code found.")
//            return
//        }
//        
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        onCodeScanned?(code)
//    }
//}


import AVFoundation
import UIKit

final class CameraManager: NSObject, ObservableObject {
    
    private let session: AVCaptureSession
    private let metadataOutput = AVCaptureMetadataOutput()
    private let photoOutput = AVCapturePhotoOutput()
    private var cameraDevice: AVCaptureDevice?
    
    private var sessionQueue = DispatchQueue(label: "com.camera.sessionQueue")
    private var accessRequestQueue = DispatchQueue(label: "com.camera.accessRequest")
    
    var onCameraError: ((String) -> Void)?
    var onPhotoCaptured: ((UIImage) -> Void)?

    init(session: AVCaptureSession = AVCaptureSession()) {
        self.session = session
        self.cameraDevice = AVCaptureDevice.default(for: .video)
        super.init()
    }
    
    func createPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        configureVideoInput()
        configurePhotoOutput()
        return AVCaptureVideoPreviewLayer(session: session)
    }
    
    func checkPermissionAndStartSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startSession()
        case .notDetermined:
            requestCameraAccess()
        default:
            onCameraError?("[Error] Camera access denied. Please enable it in Settings.")
        }
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.startSession()
                } else {
                    self?.onCameraError?("[Error] Camera access denied. Please enable it in Settings.")
                }
            }
        }
    }
    
    private func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }
    
    private func configureVideoInput() {
        guard let cameraDevice = cameraDevice else {
            onCameraError?("[Error] Camera not available.")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                onCameraError?("[Error] Unable to add video input.")
            }
        } catch {
            onCameraError?("[Error] setting up video input: \(error)")
        }
    }
    
    private func configurePhotoOutput() {
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        } else {
            onCameraError?("[Error] Photo Output")
        }
    }
    
    func capturePhoto(_ photoCompletion: @escaping (UIImage) -> Void) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        self.onPhotoCaptured = { image in
            DispatchQueue.main.async {
                photoCompletion(image)
            }
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    
    func switchCamera() {
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else {
            onCameraError?("[Error] No camera input found.")
            return
        }
        
        let newPosition: AVCaptureDevice.Position = (currentInput.device.position == .back) ? .front : .back
        
        guard let newCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else {
            onCameraError?("[Error] No available camera for selected position.")
            return
        }
        
        do {
            let newVideoInput = try AVCaptureDeviceInput(device: newCameraDevice)
            session.beginConfiguration()
            
            session.removeInput(currentInput)
            if session.canAddInput(newVideoInput) {
                session.addInput(newVideoInput)
            } else {
                session.addInput(currentInput)
            }
            
            session.commitConfiguration()
        } catch {
            onCameraError?("[Error] switching camera: \(error.localizedDescription)")
        }
    }
    
    func toggleTorch(_ isEnabled: Bool, flashMode: ((Bool) -> Void)?) {
        guard let cameraDevice = cameraDevice, cameraDevice.hasTorch else {
            onCameraError?("[Error] Flash not available.")
            return
        }
        
        do {
            try cameraDevice.lockForConfiguration()
            cameraDevice.torchMode = isEnabled ? .off : .on
            flashMode?(!isEnabled)
            cameraDevice.unlockForConfiguration()
        } catch {
            onCameraError?("[Error] toggling flash: \(error)")
        }
    }
}

// MARK: - Photo Output
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            onCameraError?("[Error] Capture Photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            onCameraError?("[Error] Cannot Take Photo.")
            return
        }
        
        DispatchQueue.main.async {
            self.onPhotoCaptured?(image)
        }
    }
}
