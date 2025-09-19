//
//  PhotoPickerViewController.swift
//  PDFMaster
//
//  Created by George Popkich on 6.02.25.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct PhotoPickerViewController: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    var completion: () -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController,
                                context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, completion: completion)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerViewController
        let completion: () -> Void

        init(_ parent: PhotoPickerViewController,
             completion: @escaping () -> Void) {
            self.parent = parent
            self.completion = completion
        }

        func picker(_ picker: PHPickerViewController, 
                    didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            let group = DispatchGroup()

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                                group.leave()
                            }
                        } else {
                            group.leave()
                        }
                    }
                }
            }

            group.notify(queue: .main) {
                if !self.parent.images.isEmpty {
                    self.completion()
                }
            }
        }
    }
    
}
