//
//  HeaderView.swift
//  PDFMaster
//
//  Created by George Popkich on 21.02.25.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var showSettings: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Welcome")
                        .font(.custom("Poppins-SemiBold", size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(minHeight: 48)
                    Spacer()
                    CircularButton(
                        image: Image(systemName: "gearshape"),
                        backgroundColor: .white,
                        foregroundColor: .black,
                        iconHeight: 18,
                        gradient: false,
                        frame: CGSize(width: 48, height: 48),
                        action: { showSettings.toggle() })
                    .buttonStyle(PlainButtonStyle())
                }
                Text("Let’s convert your files!")
                    .font(.custom("Poppins-Italic", size: 22))
                    .offset(x: 0, y: -10)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
            Spacer()
        }
    }
}


