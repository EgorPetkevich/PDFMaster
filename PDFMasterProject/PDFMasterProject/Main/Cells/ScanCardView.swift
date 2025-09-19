//
//  ScanCardView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 25.11.2024.
//
import SwiftUI

struct ScanCardView: View {
    let title: String
    let subtitle: String
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                CircularButton(
                    image: Image("mainIcon"),
                    backgroundColor: Color(hex: "F2F5FF"),
                    foregroundColor: .red,
                    iconHeight: nil,
                    gradient: false,
                    frame: CGSize(width: 64, height: 64),
                    action: {}
                ).allowsHitTesting(false)
                Spacer()
                CircularButton(
                    image: Image(systemName: "chevron.right"),
                    backgroundColor: .red,
                    foregroundColor: .white,
                    iconHeight: 20,
                    gradient: true,
                    frame: CGSize(width: 64, height: 64),
                    action: action
                )
            }
            VStack(alignment: .leading, spacing: 17) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(hex: "2E3A59"))
                Text(subtitle)
                    .font(.custom("Poppins-Medium", size: 14))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .frame(minWidth: 235, maxWidth: 250, maxHeight: 235)
        .background(RoundedRectangle(cornerRadius: 32).fill(Color.white))
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
