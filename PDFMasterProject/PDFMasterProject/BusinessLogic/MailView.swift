//
//  MailView.swift
//  PDFMaster
//
//  Created by George Popkich on 31.01.25.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    let recipients: [String] = ["cumaliabdulai@outlook.com"]
    let subject: String = "PDFMaster"
    let body: String = "Hello, I need assistance with your application."
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            controller.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.setToRecipients(recipients)
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(body, isHTML: false)
        mailComposeVC.mailComposeDelegate = context.coordinator
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
