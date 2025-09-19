//
//  PDFImporter.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 30.11.2024.
//

import SwiftUI
import UniformTypeIdentifiers
import UIKit

struct PDFImporter: UIViewControllerRepresentable {
    var onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let allowedTypes: [UTType] = [UTType.jpeg, UTType.png, UTType.plainText]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedTypes)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController,
                                context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void

        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            let accessGranted = selectedURL.startAccessingSecurityScopedResource()
            defer { selectedURL.stopAccessingSecurityScopedResource() }
            
            guard accessGranted else {
                print("[Error] No permission to access file.")
                return
            }
            onPick(selectedURL)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled")
        }
    }
}
