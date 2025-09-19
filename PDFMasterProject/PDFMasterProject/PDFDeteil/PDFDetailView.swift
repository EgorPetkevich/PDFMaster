//
//  PDFDetailView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 30.11.2024.
//


import SwiftUI
import PDFKit
import SUINavigation

struct PDFDetailView: View {
    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?
    
    @State private var isShowingShareSheet = false

    @StateObject var viewModel: PDFDeteilViewModel
    
    var body: some View {
        VStack {
            VStack {
                PDFKitView(url: $viewModel.fileURL,
                           currentPage: $viewModel.currentPage,
                           totalPages: $viewModel.totalPages)
                
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(8)
                    .shadow(radius: 4)
                    .overlay(
                        pageIndicatorView()
                            .offset(x: 0, y: -8)
                            .shadow(color: .black.opacity(0.1), radius: 3),
                        alignment: .top
                    ).offset(x: 0, y: 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.fileModel.fileName)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .navigationBarItems(
                leading: Button(action: { navigationStorage?.pop() }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
            )
            .navigationBarItems(
                trailing: Menu {
                    Button(action: { isShowingShareSheet = true }) {
                        Label {
                            Text("Share")
                                .font(.custom("Arial", size: 16))
                        } icon: {
                            Image("shareIcon")
                        }
                    }
                    
                    Button(action: { presentRenameAlert() }) {
                        Label {
                            Text("Rename")
                                .font(.custom("Helvetica Neue", size: 24))
                        } icon: {
                            Image("editIcon")
                        }
                    }
                    Button(role: .destructive, action: {
                        viewModel.deleteFile()
                    }) {
                        Label {
                            Text("Delete")
                                .font(.custom("Courier", size: 16))
                        } icon: {
                            Image("deleteIcon")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                }
            )
        }
        .navigationBarBackButtonHidden()
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
       
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(activityItems: [viewModel.fileURL])
                
        }
        .onChange(of: viewModel.popToRoot) { newValue in
            if newValue {
                navigationStorage?.pop()
            }
        }
    }

    private func pageIndicatorView() -> some View {
        Text("\(viewModel.currentPage) of \(viewModel.totalPages)")
            .font(.custom("Poppins-SemiBold", size: 16))
            .frame(height: 30)
            .foregroundColor(Color(hex: "2E3A59"))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.white)
            .cornerRadius(10)
    }
    
    
    //FIXME: - alert
    func presentRenameAlert() {
        let alertController = UIAlertController(title: "Rename your file",
                                                message: "Write your new file name",
                                                preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = nil
            textField.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let renameAction = UIAlertAction(title: "Rename", style: .default) { _ in
            if let newName = alertController.textFields?.first?.text, !newName.isEmpty {
                
                viewModel.renameFileName(newName: newName)
                
            }
        }
        alertController.addAction(renameAction)
        
        if let viewController = UIApplication.shared.currentUIWindow?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
}


