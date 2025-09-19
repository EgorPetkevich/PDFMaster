//
//  TopCellsView.swift
//  PDFMaster
//
//  Created by George Popkich on 21.02.25.
//

import SwiftUI

struct TopCellsView: View {
    @Binding var currentIndex: Int
    var scanFileSelect: () -> Void
    var mergeFileSelect: () -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: -20) {
                        ForEach(0..<2, id: \.self) { index in
                            ScanCardView(
                                title: index == 0 ? "Scan your\nfile to convert" : "Merge your\nfiles to PDF",
                                subtitle: index == 0 ? "You need to select the file or take a photo" : "You need to select minimum 2 files",
                                iconName: "doc.text.fill",
                                action: index == 0 ? scanFileSelect : mergeFileSelect
                            )
                            .scaleEffect(index == currentIndex ? 1 : 0.85)
                            .frame(height: 235)
                            .id(index)
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            .onTapGesture {
                                withAnimation {
                                    currentIndex = index
                                    proxy.scrollTo(index, anchor: .leading)
                                }
                            }
                            .padding(.leading)
                        }
                    }
                    .padding(8)
                }
                .scrollDisabled(true)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50, currentIndex < 1 {
                                withAnimation {
                                    currentIndex += 1
                                    proxy.scrollTo(currentIndex, anchor: .leading)
                                }
                            } else if value.translation.width > 50, currentIndex > 0 {
                                withAnimation {
                                    currentIndex -= 1
                                    proxy.scrollTo(currentIndex, anchor: .leading)
                                }
                            }
                        }
                )
                
                pagerView(proxy: proxy)
            }
        }
    }
    
    private func pagerView(proxy: ScrollViewProxy) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<2) { index in
                Rectangle()
                    .fill(getGradient(isCurrentIndexEquelIndex: index == currentIndex))
                    .frame(width: index == currentIndex ? 42 : 10, height: 10)
                    .cornerRadius(5)
                    .animation(.easeInOut(duration: 0.1), value: currentIndex)
                    .onTapGesture {
                        withAnimation {
                            currentIndex = index
                            proxy.scrollTo(index, anchor: .leading)
                        }
                    }
            }
        }
    }
    
    private func getGradient(isCurrentIndexEquelIndex: Bool) -> LinearGradient {
        if isCurrentIndexEquelIndex {
            return LinearGradient(
                colors: [
                    Color(hex: "FF8C8C"),
                    Color(hex: "E30010")],
                startPoint: .top,
                endPoint: .bottom)
        } else {
            return LinearGradient(
                colors: [.gray],
                startPoint: .top,
                endPoint: .bottom)
        }
    }
}
