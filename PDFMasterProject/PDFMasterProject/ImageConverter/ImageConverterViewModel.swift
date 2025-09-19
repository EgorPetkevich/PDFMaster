//
//  ImageConverterViewModel.swift
//  PDFMaster
//
//  Created by George Popkich on 11.02.25.
//

import SwiftUI
import DataStorage
import CoreData

final class ImageConverterViewModel: ObservableObject {
    var context: NSManagedObjectContext { PersistenceController.shared.container.viewContext }
    private let fileManager: FileManagerService = .instance
    
    enum ConvertAction {
        case convert
        case marge
    }
    
    @Published var images: [UIImage]
    @Published var selectedImages: [UIImage] = []
    @Published var showBottomSheet: Bool = false
    @Published var convertComplete: Bool = false
    @Published var cancelPDFCreate: Bool = false
    @Published var progress: CGFloat = 0.0
    
    var animationComplete: Bool = false {
        didSet {
            if completion {
                convertComplete = true
            }
        }
    }
    var completion: Bool = false
    
    init(images: [UIImage]) {
        self.images = images
    }
    
    func getConvertActionType() -> ConvertAction {
        selectedImages.count > 1 ? ConvertAction.marge : ConvertAction.convert
    }
    
    func createPDF() {
        fileManager.saveImagesToPDF(from: selectedImages) { [weak self] fileDTOModel in
            self?.completion = true
            self?.selectedImages.forEach { selectedImage in
                if let index = self?.images.firstIndex(of: selectedImage) {
                    self?.images.remove(at: index)
                }
            }
            self?.selectedImages.removeAll()
            
            guard
                let context = self?.context,
                let dto = fileDTOModel
            else { return }
            FileModel.create(from: dto, with: context)
        }
    }
    
    func startProgress() {
        progress = 0.0
        convertComplete = false
        showBottomSheet = true
        
        withAnimation(.easeInOut(duration: 2.0)) {
            self.progress = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                [weak self] in
                
                if
                    let cancelPDFCreate = self?.cancelPDFCreate,
                    !cancelPDFCreate
                {
                    self?.progress = 0.0
                    self?.createPDF()
                    self?.convertComplete = true
                } else {
                    self?.cancelPDFCreate = false
                }
                
            }
        }
    }
    
}
