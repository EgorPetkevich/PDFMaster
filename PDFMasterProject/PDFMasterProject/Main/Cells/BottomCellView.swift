//
//  BottomCellView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 25.11.2024.
//

import SwiftUI

struct BottomCellView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("No recent covertations")
                .font(.custom("Poppins-SemiBold", size: 24))
                .foregroundColor(.black)
                .frame(minHeight: 48)
                .padding(.top)
            HStack(spacing: 6) {
                Text("Press")
                    .font(.custom("Poppins-Medium", size: 14))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(hex: "2E3A59"))
                Image("plusIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                Text("scan files")
                    .font(.custom("Poppins-Medium", size: 14))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(hex: "2E3A59"))
            }
            Text("or")
                .font(.custom("Poppins-Medium", size: 14))
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
            Button(action: action) {
                Text("Import from files")
                    .frame(height: 58)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(Color(hex: "2E3A59"))
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 29)
                        .fill(Color(hex: "EEF2FF")))
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            
        }
        .frame(maxHeight: 217)
        .padding()
        .background(RoundedRectangle(cornerRadius: 32).fill(Color.white))
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    BottomCellView(action: {})
}
