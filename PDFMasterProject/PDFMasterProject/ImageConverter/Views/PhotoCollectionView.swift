//
//  PhotoCollectionView.swift
//  PDFMaster
//
//  Created by George Popkich on 11.02.25.
//

import SwiftUI

struct PhotoCollectionView: View {
    
    @Binding var images: [UIImage]
    @Binding var selectedImages: [UIImage]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(images, id: \.self) { image in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 162, height: 162)
                            .cornerRadius(16)
                            .clipped()
                            .onTapGesture {
                                toggleSelection(of: image)
                            }
                        if isSelected(image) {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image("checkIcon")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .padding(8)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    private func toggleSelection(of image: UIImage) {
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        } else {
            selectedImages.append(image)
        }
    }
    
    private func isSelected(_ image: UIImage) -> Bool {
        selectedImages.contains(image)
    }
    
}
