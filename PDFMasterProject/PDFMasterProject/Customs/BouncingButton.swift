//
//  BouncingButton.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 08.12.2024.
//

import SwiftUI

struct BouncingButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            provideHapticFeedback()
        }) {
            ZStack {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(LinearGradient(colors: [
                        Color(hex: "FF8C8C"),
                        Color(hex: "E30010")],
                                               startPoint: .top,
                                               endPoint: .bottom))
                    .cornerRadius(64)
                    .scaleEffect(isPressed ? 1.0 : 0.95)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                HStack {
                    Spacer()
                    Image("arrowButton")
                        .resizable()
                        .frame(width: 48, height: 48)
                }.padding()
            }.frame(height: 64)
        }
    }
    
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    BouncingButton(title: "Subscribe for $6.99/week\nAuto renewable. Cancel anytime.", action: {})
}
