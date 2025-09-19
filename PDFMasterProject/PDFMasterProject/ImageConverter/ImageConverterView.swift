//
//  ImageConverterView.swift
//  PDFMaster
//
//  Created by George Popkich on 10.02.25.
//

import SwiftUI
import SUINavigation
import DataStorage

struct ImageConverterView: View {
    
    private enum Constants {
        static let alertBottomViewSubTitle: String = "It would take some time"
        
        static func titleText(
            _ action: ImageConverterViewModel.ConvertAction
        ) -> String {
            switch action {
            case .convert:
                return "Covert to PDF"
            case .marge:
                return "Merge files to PDF"
            }
        }
        
        static func actionButtonText(
            _ action: ImageConverterViewModel.ConvertAction
        ) -> String {
            switch action {
            case .convert:
                return "Convert"
            case .marge:
                return "Marge"
            }
        }
        
        static func alertBottomViewTitle(
            _ action: ImageConverterViewModel.ConvertAction
        ) -> String {
            switch action {
            case .convert:
                return "File converting..."
            case .marge:
                return "Files merging..."
            }
        }
        
        static func alertBottomViewTitleOnCompletion(
            _ action: ImageConverterViewModel.ConvertAction
        ) -> String {
            switch action {
            case .convert:
                return "File succesfully coverted"
            case .marge:
                return "Files succesfully merged"
            }
        }
    }
    
    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?
    
    @StateObject var viewModel: ImageConverterViewModel
    
    @State private var isPickerPresented: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                
                HStack {
                    Button(action: { navigationStorage?.popToRoot()  }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    Text(Constants.titleText(viewModel.getConvertActionType()))
                        .font(.poppinsFont(size: 20, weight: .semibold))
                        .foregroundStyle(Color.appBlack)
                        .padding(.vertical)
                    
                    Spacer()
                    Button(action: { isPickerPresented.toggle() }) {
                        Text("Add")
                            .font(.poppinsFont(size: 20, weight: .semibold))
                            .foregroundStyle(Color.appButtonRed)
                    }
                    .sheet(isPresented: $isPickerPresented) {
                        PhotoPickerViewController(images: $viewModel.images) { }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.horizontal)
                
                PhotoCollectionView(images: $viewModel.images,
                                    selectedImages: $viewModel.selectedImages)
                .padding(.horizontal, 16)
                
                if !$viewModel.selectedImages.isEmpty {
                    ActionButtonView(title: Constants.actionButtonText(
                        viewModel.getConvertActionType())) {
                            viewModel.startProgress()
                        }
                }
            }
            
            if viewModel.showBottomSheet {
                
                BlurView(style: .systemUltraThinMaterialDark)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                
                VStack {
                    if !viewModel.convertComplete {
            
                        Spacer()
                        Text(Constants.alertBottomViewTitle(
                            viewModel.getConvertActionType()))
                            .font(.poppinsFont(size: 20,
                                               weight: .semibold))
                            .foregroundStyle(Color.appWhite)
                        Text(Constants.alertBottomViewSubTitle)
                            .font(.poppinsFont(size: 13))
                            .foregroundStyle(Color.appWhite)
                            .padding(.bottom, 24)
                        
                        
                        ProgressBar(progress: $viewModel.progress)
                            .frame(height: 6)
                            .padding(.horizontal, 32)
                    }
                    
                    Spacer()
                    AlertBottomView(isPresented: $viewModel.showBottomSheet,
                                    convertComplete: $viewModel.convertComplete,
                                    progress: $viewModel.progress,
                                    titleOnCompletion: Constants.alertBottomViewTitleOnCompletion(
                                        viewModel.getConvertActionType())
                                    ,
                                    titleText: Constants.alertBottomViewTitle(
                                        viewModel.getConvertActionType()),
                                    subTitleText: Constants.alertBottomViewSubTitle,
                                    cancelButtonDidTap: {
                        viewModel.cancelPDFCreate = true
                    })
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .cornerRadius(24)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .bottom))
                }
                .zIndex(2)
            }
        }
    }

    
}

#Preview {
    ImageConverterView(viewModel: ImageConverterViewModel(images:  [.mainAppIcon]))
}
