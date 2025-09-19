//
//  SettingsRow.swift
//  PDFMaster
//
//  Created by George Popkich on 30.01.25.
//

import SwiftUI

struct SettingsRow: View {
    @State private var isPressed = false
    
    var icon: Image
    var title: String
    
    var rowDidSelect: () -> Void
    
    var body: some View {
        Button(action: {
            rowDidSelect()
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
            
        })
        {
        HStack {
            icon
                .padding(.leading, 19)
            Text(title)
                .font(.custom("Poppins-Medium", size: 16))
                .foregroundColor(.black)
                .padding(.leading, 19)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
                .padding(.trailing, 16)
        }
        .frame(height: 55)
        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
        .background(isPressed ? Color.gray.opacity(0.3) : Color(hex: "#FFFFFF"))
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .cornerRadius(24)
    }
        .buttonStyle(PlainButtonStyle())
    }
}
