//
//  ShareController.swift
//  PDFMaster
//
//  Created by George Popkich on 31.01.25.
//

import SwiftUI

struct ShareController: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
