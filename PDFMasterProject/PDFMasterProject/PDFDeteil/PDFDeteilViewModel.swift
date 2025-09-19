//
//  PDFDeteilViewModel.swift
//  PDFMaster
//
//  Created by George Popkich on 21.02.25.
//

import Foundation
import DataStorage

final class PDFDeteilViewModel: ObservableObject {
    
    @Published var fileModel: FileModel
    @Published var fileURL: URL
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 0
    @Published var popToRoot: Bool = false
    
    private let fileManager: FileManagerService = .instance
    
    init(fileModel: FileModel) {
        self.fileModel = fileModel
        self.fileURL = FileManagerService.getURL(fileUrl: fileModel.fileUrl)
        countNumOfPages()
    }
    
    private func countNumOfPages() {
        totalPages = FileManagerService.getPageCount(fileUrl: fileModel.fileUrl)
    }
    
    func renameFileName(newName: String) {
        fileManager.renameFile(fileUrl: fileModel.fileUrl,
                               newName: newName) { [weak self] fileModel in
            self?.fileModel.name = fileModel?.name
            self?.fileModel.url = fileModel?.url
            self?.fileModel.managedObjectContext?.saveContext()
            self?.updateFileURL()
        }
    }
    
    func updateFileURL() {
        fileURL = FileManagerService.getURL(fileUrl: fileModel.fileUrl)
    }
    
    func deleteFile() {
        fileManager.deleteFile(fileUrl: fileModel.fileUrl) { [weak self] in
            guard let self else { return }
            FileModel.delete(file: self.fileModel)
            self.popToRoot = true
        }
       
    }
    
    
}
