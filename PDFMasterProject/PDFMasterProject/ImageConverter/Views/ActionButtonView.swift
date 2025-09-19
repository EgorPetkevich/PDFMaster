//
//  ActionButtonView.swift
//  PDFMaster
//
//  Created by George Popkich on 11.02.25.
//

import SwiftUI

struct ActionButtonView: View {
//    @Binding var showBottomSheet: Bool
   
    var title: String
    var onAction: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                onAction()
            }
        }) {
            Text(title)
            .font(.poppinsFont(size: 16, weight: .semibold))
            .foregroundColor(.appWhite)
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .background(LinearGradient(colors: [
                Color(hex: "FF8C8C"),
                Color(hex: "E30010")],
                                       startPoint: .top,
                                       endPoint: .bottom))
            .cornerRadius(34)
            .multilineTextAlignment(.center)
            .padding(.bottom)
            .padding(.horizontal, 36)
        }
    }
}
