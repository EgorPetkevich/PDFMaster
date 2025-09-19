//
//  MainView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 20.11.2024.
//

import SwiftUI
import SUINavigation
import PDFKit
import DataStorage

struct MainView: View {
    
    private enum Constants {
        static let alertBottomViewSubTitle: String = "It would take some time"
        
        static func alertBottomViewTitle(
            _ action: MainViewModel.ConvertAction
        ) -> String {
            switch action {
            case .convert:
                return "File converting..."
            case .marge:
                return "Files merging..."
            }
        }
        
        static func alertBottomViewTitleOnCompletion(
            _ action: MainViewModel.ConvertAction
        ) -> String {
            switch action {
            case .convert:
                return "File succesfully coverted"
            case .marge:
                return "Files succesfully merged"
            }
        }
    }
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: FileModel.fetch(), animation: .default)

    private var files: FetchedResults<FileModel>
    var apphudService: ApphudService
    
    @StateObject var viewModel: MainViewModel
    @State private var showBottomSheet = false
    @State private var showSettings = false
    
    @State private var selectedFile: FileModel?
    @State private var showPDFImporter = false
    @State private var showPDFsImporter = false
    @State private var showPDFDetail = false
    
    @State private var showImagePicker = false
    
    @State private var showShareSheet = false
    @State private var shareFileUrl: URL?

    var body: some View {
        NavigationViewStorage {
            ZStack {
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderView(showSettings: $showSettings)
                        .padding(.horizontal)
                        .padding(.top)
                    TopCellsView(currentIndex: $viewModel.currentIndex,
                                 scanFileSelect: {showBottomSheet.toggle()},
                                 mergeFileSelect: {showPDFsImporter.toggle()})
                    
                    if files.isEmpty {
                        BottomCellView(action: { showPDFImporter.toggle() } )
                            .padding()
                    } else {
                        VStack {
                            HStack {
                                Text("Resents")
                                    .foregroundColor(.appBlack)
                                    .font(.poppinsFont(size: 16,
                                                       weight: .semibold))
                                    .padding(.top, 24)
                                    .padding(.bottom, 15)
                                    .padding(.horizontal, 16)
                                Spacer()
                            }
                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(files) { file in
                                        
                                        FileRowView(file: file) {
                                            showPDFDetail = true
                                            selectedFile = file
                                        } onDelete: {
                                            presentDeleteAlert(for: file)
                                        } onRename: {
                                            presentRenameAlert(for: file)
                                        } onShare: {
                                            viewModel.shareFile(from: file)
                                        }
                                    }
                                    
                                }
                                
                            }.padding(.horizontal, 16)
                                .padding(.bottom, 16)
                        }
                    }
                    Spacer()
                    
                }
                .edgesIgnoringSafeArea(.bottom)
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
            
                
                if files.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            CircularButton(
                                image: Image(systemName: "plus"),
                                backgroundColor: .red,
                                foregroundColor: .white,
                                iconHeight: 20,
                                gradient: true,
                                frame: CGSize(width: 64, height: 64),
                                action: { showBottomSheet.toggle() })
                            .padding()
                        }
                    }
                }
                if showBottomSheet {
                    BlurView(style: .systemUltraThinMaterialDark)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showBottomSheet.toggle()
                            }
                        }
                }
                VStack {
                    Spacer()
                    HStack {
                        withAnimation {
                            CustomAlertView(
                                isPresented: $showBottomSheet,
                                takeShotAction: {
                                    showImagePicker.toggle()
                                }, selectPictureAction: {
                                    showPDFImporter.toggle()
                                    showBottomSheet.toggle()
                                })
                            .cornerRadius(24)
                            .frame(height: UIScreen.main.bounds.height * 0.5)
                            .transition(.move(edge: .bottom))
                            .offset(y: showBottomSheet ? 0 : UIScreen.main.bounds.height * 0.5)
                            .padding()
                        }
                    }
                }
                
                .ignoresSafeArea()
            }.navigation(isActive: $showSettings){
                
                SettingsView(viewModel: SettingsViewModel())
                    .navigationBarBackButtonHidden()
            }

            .navigation(isActive: $showPDFDetail, destination: {
                if let selectedFile {
                    PDFDetailView(viewModel: PDFDeteilViewModel(fileModel: selectedFile))
                }
            })
            .navigationAction(isActive: $showImagePicker, destination: {
                CameraScreenView().navigationBarBackButtonHidden()
            })

            .sheet(isPresented: $showPDFImporter) {
                PDFImporter { url in
                    viewModel.startProgressConvert(from: url)
                }
        
            }
            .sheet(isPresented: $showPDFsImporter) {
                PDFsImporter { urls in
                    viewModel.startProgressConvert(from: urls)
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let shareFileUrl {
                    ShareSheet(activityItems: [shareFileUrl])
                }
            }
            .sheet(isPresented: $viewModel.isSharing) {
                ShareController(items: [viewModel.shearingURL ?? AppConfig.share] )
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background && !viewModel.isPremium() {
                    viewModel.showPaywall = true
                }
            }
            .fullScreenCover(isPresented: $viewModel.showPaywall) {
                getPaywall()
            }
        }
    }
    
    //FIXME: - alert
    func presentRenameAlert(for file: FileModel) {
        let alertController = UIAlertController(
            title: "Rename your file",
            message: "Write your new file name",
            preferredStyle: .alert)
        

        alertController.addTextField { textField in
            textField.text = nil
            textField.autocapitalizationType = .words
        }

        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        let renameAction = UIAlertAction(title: "Rename",
                                         style: .default
        ) { _ in
            if
                let newName = alertController.textFields?.first?.text,
                !newName.isEmpty
            {
                viewModel.renameFileName(from: file, newName: newName)
            }
        }
        alertController.addAction(renameAction)
        
        if let viewController = 
            UIApplication.shared.currentUIWindow?.rootViewController {
            viewController.present(alertController, 
                                   animated: true,
                                   completion: nil)
        }
    }
    
    func presentDeleteAlert(for file: FileModel) {
        let alertController = UIAlertController(
            title: "Do you want to delete file?",
            message: nil,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", 
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .destructive) { _ in
            self.deleteFile(file: file)
        }
        alertController.addAction(deleteAction)
        
        if let viewController = 
            UIApplication.shared.currentUIWindow?.rootViewController {
            viewController.present(alertController,
                                   animated: true,
                                   completion: nil)
        }
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            FileModel.delete(at: offsets, for: Array(files))
        }
    }
    
    private func deleteFile(file: FileModel) {
        withAnimation {
            viewModel.deleteFileContent(from: file) {
                FileModel.delete(file: file)
            }
        }
    }
    
    private func getPaywall() -> AnyView {
        if UDManager.getValue(forKey: .isReview) {
            AnyView(ReviewPaywallView(viewModel: ReviewPaywallViewModel {}))
        } else {
            AnyView(ProdPaywallView(viewModel: ProdPaywallViewModel {}, showPageContorl: false))
        }
    }

    
}
