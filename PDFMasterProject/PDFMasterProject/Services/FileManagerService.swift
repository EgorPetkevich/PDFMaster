//
//  FileManagerService.swift
//  PDFMaster
//
//  Created by George Popkich on 21.02.25.
//

import DataStorage
import UIKit
import PDFKit

final class FileManagerService {
    
    typealias CompletionHandler = (FileDTOModel?) -> Void
    
    enum NameOfDirectory: String {
        case Documents
    }
    
    static let instance = FileManagerService()
    
    private init() { }
    
    static func createDirectory(name directory: NameOfDirectory) {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        var url = documentURL.appendingPathComponent(directory.rawValue)
        
        do {
            try FileManager.default.createDirectory(
                at: url, withIntermediateDirectories: true,
                attributes: nil)
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = false
            try url.setResourceValues(resourceValues)
        } catch {
            print("Error creating directory: \(error)")
        }
    }
    
    static func getURL(fileUrl: String) -> URL {
        let directoryURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first!
            .appendingPathComponent(NameOfDirectory.Documents.rawValue)
        let fileURL = directoryURL.appendingPathComponent(fileUrl)
        
        return fileURL
    }
    
    static func getPageCount(fileUrl: String) -> Int {
        guard
            let document = PDFDocument(url: getURL(fileUrl: fileUrl))
        else {
            return 0
        }
        return document.pageCount
    }
    
    private func generatePDF(from images: [UIImage]) -> Data? {
        let pdfMetaData: [CFString: Any] = [
            kCGPDFContextCreator: "Photo to PDF Converter",
            kCGPDFContextAuthor: "PDFMaster App"
        ]
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, pdfMetaData)
        
        for image in images {
            let imageRect = CGRect(x: 0, y: 0,
                                   width: image.size.width,
                                   height: image.size.height)
            UIGraphicsBeginPDFPageWithInfo(imageRect, nil)
            image.draw(in: imageRect)
        }
        
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
    
    func saveImagesToPDF(
        from images: [UIImage],
        completion: CompletionHandler?
    ) {
        guard let pdfData = generatePDF(from: images) else {
            print("[Error] Failed to create PDF.")
            completion?(nil)
            return
        }
        let id = UUID().uuidString
        let fileName = "Document_\(id).pdf"
        let directoryURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first!
            .appendingPathComponent(NameOfDirectory.Documents.rawValue)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: fileURL)
            print("PDF created successfully: \(fileURL)")
            addRecentFile(fileName: fileName,
                          url: fileURL,
                          id: id, completion: completion)
        } catch {
            print("[Error] Failed to save PDF: \(error.localizedDescription)")
            completion?(nil)
        }
    }
    
    private func addRecentFile(
        fileName: String,
        url: URL,
        id: String,
        completion: CompletionHandler?
    ) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("[Error] File not found at path: \(url.path)")
            completion?(nil)
            return
        }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            let fileSize = attributes[.size] as? Int64 ?? 0
            let sizeString = ByteCountFormatter.string(fromByteCount: fileSize,
                                                       countStyle: .file)
            
            let newFile = FileDTOModel(id: id,
                                       name: fileName,
                                       size: sizeString,
                                       type: "JPG",
                                       url: fileName)
            completion?(newFile)
        } catch {
            print("[Error] Failed to retrieve file attributes: \(error.localizedDescription)")
            completion?(nil)
        }
    }
    
    func deleteFile(
        fileUrl: String,
        completion: (() -> Void)?
    ) {
        let directoryURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first!
            .appendingPathComponent(NameOfDirectory.Documents.rawValue)
        let fileURL = directoryURL.appendingPathComponent(fileUrl)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("[Error] File not found at path: \(fileURL.path)")
            return
        }
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("File successfully deleted: \(fileURL.path)")
            completion?()
        } catch {
            print("[Error] Failed to delete file: \(error.localizedDescription)")
        }
    }
    
    func renameFile(
        fileUrl: String,
        newName: String,
        completion: ((FileDTOModel?) -> Void)?
    ) {
        let directoryURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first!
            .appendingPathComponent(NameOfDirectory.Documents.rawValue)
        let fileURL = directoryURL.appendingPathComponent(fileUrl)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("[Error] File not found at path: \(fileURL.path)")
            completion?(nil)
            return
        }
        
        let newFileName = newName.hasSuffix(".pdf") ? newName : "\(newName).pdf"
        let newFileURL = directoryURL.appendingPathComponent(newFileName)
        
        do {
            try FileManager.default.moveItem(at: fileURL, to: newFileURL)
            print("File successfully renamed to: \(newFileURL.path)")
            completion?(FileDTOModel(id: UUID().uuidString,
                                     name: newName,
                                     size: "",
                                     type: "",
                                     url: newFileURL.lastPathComponent))
        } catch {
            print("[Error] Failed to rename file: \(error.localizedDescription)")
            completion?(nil)
        }
    }
    
    func getFileForSharing(
        fileName: String,
        completion: @escaping (URL?) -> Void
    ) {
        let directoryURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first!
            .appendingPathComponent(NameOfDirectory.Documents.rawValue)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("[Error] File not found at path: \(fileURL.path)")
            completion(nil)
            return
        }
        completion(fileURL)
    }
    
    func createPDF(from url: URL, completion: ((FileDTOModel?) -> Void)?) {
        
        let fileType = getFileType(from: url)
        let id = UUID().uuidString
        let fileName = "Document_\(id).pdf"
        
        let directoryURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first!
            .appendingPathComponent(NameOfDirectory.Documents.rawValue)
        
        let fileURL = directoryURL.appendingPathComponent(fileName)
        let pdfDocument = PDFDocument()
        
        if fileType == "Image", let image = UIImage(contentsOfFile: url.path) {
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: 0)
        } else  {
            do {
                let text = try String(contentsOf: url)
                let textPage = PDFPage(text: text)
                pdfDocument.insert(textPage, at: 0)
            } catch {
                print("[Error] read: \(error)")
                completion?(nil)
                return
            }
        }
        
        guard let pdfData = pdfDocument.dataRepresentation() else {
            print("[Error] PDF cannot create")
            completion?(nil)
            return
        }
        
        do {
            if let data = pdfDocument.dataRepresentation() {
                if !FileManager.default.fileExists(atPath: directoryURL.path) {
                    try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                }
                try data.write(to: fileURL)

            print("PDF created successfully: \(fileURL)")
            
            let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path)
            let fileSize = fileAttributes?[.size] as? Int64 ?? 0
            let fileSizeString = ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
            
        
                let fileDTO = FileDTOModel(
                    id: id,
                    name: fileName,
                    size: fileSizeString,
                    type: url.pathExtension.uppercased(),
                    url: fileURL.lastPathComponent
                )
                completion?(fileDTO)
            } else {
                print("[Error] Failed to generate PDF data.")
                completion?(nil)
            }
        } catch {
            print("[Error] Failed to save PDF: \(error.localizedDescription)")
            completion?(nil)
        }
    }


    func mergePDF(from urls: [URL], completion: ((FileDTOModel?) -> Void)?) {
        guard !urls.isEmpty else {
            print("[Error] No files to merge.")
            completion?(nil)
            return
        }

        let id = UUID().uuidString
        let fileName = "Document_\(id).pdf"
        let directoryURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first!
            .appendingPathComponent(NameOfDirectory.Documents.rawValue)
        let fileURL = directoryURL.appendingPathComponent(fileName)

        let pdfDocument = PDFDocument()

        for (_, url) in urls.enumerated() {
            
            let fileType = getFileType(from: url)
            if fileType == FileType.PDF.rawValue {
                guard let document = PDFDocument(url: url) else {
                    print("[Error] Failed to load PDF: \(url.lastPathComponent)")
                    continue
                }
                for pageIndex in 0..<document.pageCount {
                    guard let page = document.page(at: pageIndex) else { continue }
                    pdfDocument.insert(page, at: pdfDocument.pageCount)
                }
                
                
            } else if fileType == FileType.Image.rawValue, let image = UIImage(contentsOfFile: url.path) {
                
                let pdfPage = PDFPage(image: image)
                pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
                
            } else if fileType == FileType.TextFile.rawValue {
                
                if let text = (try? String(contentsOf: url)) {
                    let textPage = PDFPage(text: text)
                    pdfDocument.insert(textPage, at: pdfDocument.pageCount)
                }
               
            } else {
                print("[Error] Unsupported file type: \(url.lastPathComponent)")
            }
        }

        do {
            if let data = pdfDocument.dataRepresentation() {
                if !FileManager.default.fileExists(atPath: directoryURL.path) {
                    try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                }
                try data.write(to: fileURL)
                print("PDF merged successfully: \(fileURL)")

                let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path)
                let fileSize = fileAttributes?[.size] as? Int64 ?? 0
                let fileSizeString = ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)

                
                let fileDTO = FileDTOModel(
                    id: id,
                    name: fileName,
                    size: fileSizeString,
                    type: urls.first!.pathExtension.uppercased(),
                    url: fileURL.lastPathComponent
                )
                completion?(fileDTO)
            } else {
                print("[Error] Failed to generate PDF data.")
                completion?(nil)
            }
        } catch {
            print("[Error] Failed to save merged PDF: \(error.localizedDescription)")
            completion?(nil)
        }
    }


    private enum FileType: String {
        case PDF
        case Image
        case TextFile
    }

  
    private func getFileType(from fileURL: URL) -> String {
        let fileExtension = fileURL.pathExtension.lowercased()
       
        
        switch fileExtension {
        case "pdf":
            return FileType.PDF.rawValue
        case "jpg", "jpeg", "png":
            return FileType.Image.rawValue
        case "txt":
            return FileType.TextFile.rawValue
        default:
            return "Unknown"
        }
    }

    
}


extension PDFPage {
    convenience init(text: String) {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        UIGraphicsBeginImageContext(pageRect.size)
        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(UIColor.white.cgColor)
        context.fill(pageRect)

        let textRect = CGRect(x: 20, y: 20, width: pageRect.width - 40, height: pageRect.height - 40)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle
        ]
        NSString(string: text).draw(in: textRect, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.init(image: image!)!
    }
}
