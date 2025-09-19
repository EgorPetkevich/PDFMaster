//
//  FileRowView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 27.11.2024.
//

import SwiftUI
import DataStorage

struct FileRowView: View {
    @State private var isPressed = false
    
    let file: FileModel
    let fileDidSelect: () -> Void
    let onDelete: () -> Void
    let onRename: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                fileDidSelect()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }) {
                HStack {
                    Image(file.iconName ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.blue)
                        .padding(.trailing, 8)
                    
                    VStack(alignment: .leading) {
                        Text(file.name ?? "")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Imported as \(file.type ?? "") - \(file.size ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(20)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Menu {
                Button(action: onShare) {
                    Label {
                        Text("Share")
                    } icon: {
                        Image("shareIcon")
                    }
                }
                Button(action: onRename) {
                    Label {
                        Text("Rename")
                    } icon: {
                        Image("editIcon")
                    }
                }
                Button(role: .destructive, action: onDelete) {
                    Label {
                        Text("Delete")
                    } icon: {
                        Image("deleteIcon")
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
            }
            .frame(width: 24, height: 24)
            .padding(.trailing, 20)
        }
        .frame(height: 85)
        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
        .background(isPressed ? Color.gray.opacity(0.3) : Color(hex: "#FFFFFF"))
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .cornerRadius(18)
    }
}
