//
//  UnlockPremiumRow.swift
//  PDFMaster
//
//  Created by George Popkich on 30.01.25.
//

import SwiftUI

struct UnlockPremiumRow: View {
    
    private let icon: Image =  Image.Settings.pdf
    private let title: String = "Unlock Premium Features"
    private let subTitle: String =  "Get unlimited access to\nadvanced tools & all benefits"
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    icon.padding(.leading, 17)
                }
                
                VStack {
                    Text(title)
                        .font(.custom("Poppins-SemiBold", size: 15))
                        .foregroundColor(.white)
                    
                    Text(subTitle)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(.white).multilineTextAlignment(.leading)
                        .padding(.leading, -20)
                }.padding(.leading, 10)
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
            }
            .frame(height: 95)
            .background(LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#FF8C8C"),
                                            Color(hex: "#E30010")]),
                startPoint: .top, endPoint: .bottom))
            .cornerRadius(32)
           
            HStack {
                Image("settings_crown")
                    .padding(.bottom, 0)
                    .padding(.leading, -10)
                    .zIndex(2)
                    .offset(x: 0, y: -50)
                Spacer()
            }
            
        }
        .zIndex(2)
        .padding(.top, 14)
        .padding(.horizontal, 16)
        .frame(height: 109)
    }

}
