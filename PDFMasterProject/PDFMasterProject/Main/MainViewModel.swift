//
//  MainViewModel.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 10.12.2024.
//


import SwiftUI
import SUINavigation
import PDFKit
import DataStorage
import CoreData

final class MainViewModel: ObservableObject {
    var context: NSManagedObjectContext { PersistenceController.shared.container.viewContext }
    
    enum ConvertAction {
        case convert
        case marge
    }
    
    @Published var currentIndex: Int = 0
    @Published var isSharing: Bool = false
    @Published var showBottomSheet: Bool = false
    @Published var convertComplete: Bool = false
    @Published var cancelPDFCreate: Bool = false
    @Published var progress: CGFloat = 0.0
    @Published var showPaywall: Bool = false
    
    private var currentAction: ConvertAction = .convert
    var shearingURL: URL? = nil
    
    private let fileManager: FileManagerService = .instance
    private var apphudSerivese: ApphudService = .instance
    
    
    func moveToNextCard() {
        currentIndex = (currentIndex + 1) % 2
    }
    
    func getConvertActionType() -> ConvertAction {
        return currentAction
    }
    
    func isPremium()  -> Bool {
        return UDManager.getValue(forKey: .isPremium)
    }
    
    func deleteFileContent(from file: FileModel, completion: (() -> Void)?) {
        
        fileManager.deleteFile(fileUrl: file.fileUrl, completion: completion)
    }
    
    func renameFileName(from file: FileModel, newName: String) {
        fileManager.renameFile(fileUrl: file.fileUrl,
                               newName: newName) { fileModel in
            file.name = fileModel?.name
            file.url = fileModel?.url
            file.managedObjectContext?.saveContext()
        }
    }
    
    func shareFile(from file: FileModel) {
        fileManager.getFileForSharing(fileName: file.fileUrl) { url in
            self.shearingURL = url
            self.isSharing = true
        }
    }
    
    func convertFile(from url: URL) {
        fileManager.createPDF(from: url) { [weak self] fileDTOModel in
            guard
                let context = self?.context,
                let dto = fileDTOModel
            else { return }
            FileModel.create(from: dto, with: context)
        }
    }
    
    func margeFiles(from urls: [URL]) {
        fileManager.mergePDF(from: urls) { [weak self] fileDTOModel in
            guard
                let context = self?.context,
                let dto = fileDTOModel
            else { return }
            FileModel.create(from: dto, with: context)
        }
    }
    
    func startProgressConvert(from url: URL) {
        progress = 0.0
        convertComplete = false
        showBottomSheet = true
        currentAction = .convert
        withAnimation(.easeInOut(duration: 2.0)) {
            self.progress = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                [weak self] in
                
                if
                    let cancelPDFCreate = self?.cancelPDFCreate,
                    !cancelPDFCreate
                {
            
                    let accessGranted = url.startAccessingSecurityScopedResource()
                    defer { url.stopAccessingSecurityScopedResource() }
                    self?.progress = 0.0
                    self?.convertFile(from: url)
                    self?.convertComplete = true
                } else {
                    self?.cancelPDFCreate = false
                }
                
            }
        }
    }
    
    func startProgressConvert(from urls: [URL]) {
        progress = 0.0
        convertComplete = false
        showBottomSheet = true
        currentAction = .marge
        withAnimation(.easeInOut(duration: 2.0)) {
            self.progress = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                [weak self] in
                
                if
                    let cancelPDFCreate = self?.cancelPDFCreate,
                    !cancelPDFCreate
                {
                    let validURLs = urls.filter { $0.startAccessingSecurityScopedResource() }
                    defer {validURLs.forEach { $0.stopAccessingSecurityScopedResource()}}
                    guard !validURLs.isEmpty else {
                        print("[Error] No permission to access files.")
                        return
                    }
                    self?.progress = 0.0
                    self?.margeFiles(from: urls)
                    self?.convertComplete = true
                } else {
                    self?.cancelPDFCreate = false
                }
                
            }
        }
    }
    
}

