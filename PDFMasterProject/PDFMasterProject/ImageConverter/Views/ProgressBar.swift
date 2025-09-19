//
//  ProgressBar.swift
//  PDFMaster
//
//  Created by George Popkich on 22.02.25.
//

import SwiftUI

struct ProgressBar: View {
    
    @Binding var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.appButtonRed)
                    .frame(width: geometry.size.width * progress, height: 6)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
        }
    }
}
