//
//  CircularButton.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 25.11.2024.
//

import SwiftUI

struct CircularButton: View {
    let image: Image
    let backgroundColor: Color
    let foregroundColor: Color
    let iconHeight: CGFloat?
    let gradient: Bool
    let frame: CGSize
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if gradient {
                    LinearGradient(
                        colors: [Color(hex: "FF8C8C"), Color(hex: "E30010")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(Circle())
                } else {
                    backgroundColor.clipShape(Circle())
                }
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconHeight ?? frame.width / 2, height: iconHeight ?? frame.height / 2)
                    .foregroundColor(foregroundColor)
            }
            .frame(width: frame.width, height: frame.height)
        }
    }
}

