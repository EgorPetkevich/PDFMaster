import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    @Binding var url: URL
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let document = PDFDocument(url: url) {
            print("PDF write to: \(url)")
            pdfView.document = document
            pdfView.autoScales = true
            pdfView.delegate = context.coordinator
            
            // Установка общего количества страниц
            DispatchQueue.main.async {
                totalPages = document.pageCount
            }
        } else {
            print("[ERROR]: Not found PDFDocument from URL: \(url)")
        }
        
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.pageChanged),
            name: .PDFViewPageChanged,
            object: pdfView
        )
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        guard let document = pdfView.document else { return }

        let visiblePageIndex = document.index(
            for: pdfView.currentPage ?? document.page(at: 0)!)
        if visiblePageIndex + 1 != currentPage {
            DispatchQueue.main.async {
                self.currentPage = visiblePageIndex + 1
            }
        }
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, currentPage: $currentPage, totalPages: $totalPages)
    }
    
    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFKitView
        @Binding var currentPage: Int
        @Binding var totalPages: Int
        
        init(_ parent: PDFKitView, 
             currentPage: Binding<Int>,
             totalPages: Binding<Int>) {
            self.parent = parent
            self._currentPage = currentPage
            self._totalPages = totalPages
        }
        
        func pdfView(_ pdfView: PDFView, 
                     didChangePageFor document: PDFDocument) {
            if let page = pdfView.currentPage,
               let document = pdfView.document {
                let currentPageIndex = document.index(for: page) + 1
                DispatchQueue.main.async {
                    self.currentPage = currentPageIndex
                }
            }
        }
        
        @objc func pageChanged(notification: Notification) {
            guard let pdfView = notification.object as? PDFView,
                  let current = pdfView.currentPage,
                  let document = pdfView.document else { return }
            DispatchQueue.main.async {
                self.currentPage = document.index(for: current) + 1
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self,
                                                      name: .PDFViewPageChanged,
                                                      object: nil)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: Context) {}
}


