//
//  PDFsImorter.swift
//  PDFMaster
//
//  Created by George Popkich on 24.02.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct PDFsImporter: UIViewControllerRepresentable {
    var onPick: ([URL]) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let allowedTypes: [UTType] = [UTType.jpeg, UTType.png, UTType.plainText, UTType.pdf]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedTypes)
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: ([URL]) -> Void

        init(onPick: @escaping ([URL]) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            let validURLs = urls.filter { $0.startAccessingSecurityScopedResource() }
            defer {validURLs.forEach { $0.stopAccessingSecurityScopedResource()}}
            guard !validURLs.isEmpty else {
                print("[Error] No permission to access files.")
                return
            }
            onPick(validURLs)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled")
        }
    }
}

