//
//  CameraScreenView.swift
//  PDFMaster
//
//  Created by George Popkich on 6.02.25.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct CameraScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var alertService: AlertService = .instance
    @StateObject private var viewModel = CameraScreenViewModel()

    @State private var isButtonDisabled = false
    @State private var isFlashOn: Bool = false
    @State private var isPickerPresented: Bool = false
    
    @State private var dragOffset: CGFloat = 0
    
    @State private var showImageConverter: Bool = false
    
    var body: some View {
        ZStack {
            CameraView(cameraManager: viewModel.getCameraManager())
                .cornerRadius(24)
                .edgesIgnoringSafeArea(.all)
            
            BlurredOverlayMask()
            
            VStack {
                HStack {
                    Button(action: {
                        isPickerPresented.toggle()
                    }) {
                        Image("galleryIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.appWhiteCameraButton)
                            .padding(15)
                    }
                    .sheet(isPresented: $isPickerPresented) {
                        PhotoPickerViewController(images: $viewModel.images) {
                            showImageConverter = true
                        }
                    }
                    
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleTorch()
                    }) {
                        Image(systemName: viewModel.flashMode ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.appWhiteCameraButton)
                            .padding(15)
                    }
                    
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.switchCamera()
                    }) {
                        Image("flipCameraIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.appWhiteCameraButton)
                            .padding(15)
                    }
                }
                .padding(.horizontal, 50)
                .padding(.top)
                
                Spacer()
                
                Image("shutterIcon")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .onTapGesture {
                        isButtonDisabled = true
                        viewModel.capturePhoto { photo in
                            self.viewModel.images = [photo]
                            self.isButtonDisabled = false
                            self.showImageConverter = true
                        }
                    }
                    .padding(.bottom, 38)
                    .disabled(isButtonDisabled)
            }
        }
        .offset(x: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.width > 0 {
                        dragOffset = gesture.translation.width
                    }
                }
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                    withAnimation {
                        dragOffset = 0
                    }
                }
        )
        .alert(item: $alertService.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message ?? ""),
                primaryButton: alertItem.primaryButton ?? .default(Text("OK")),
                secondaryButton: .cancel()
            )
        }
        .navigationAction(isActive: $showImageConverter) {
            ImageConverterView(
                viewModel: ImageConverterViewModel(
                    images: viewModel.images))
            .navigationBarBackButtonHidden()
        }
    }
    
}


struct BlurredOverlayMask: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BlurView(style: .light)
                    .edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .cornerRadius(24)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 142)
                    .padding(.top, 75)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
        }
    }
}

