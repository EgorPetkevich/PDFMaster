//
//  ProgresAppView.swift
//  PDFMaster
//
//  Created by George Popkich on 25.02.25.
//

import SwiftUI

struct ProgresAppView: View {
    var body: some View {
        Image("mainAppIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .background(Color(hex: "#F2F5FF"))
            .cornerRadius(30)
    }
}

#Preview {
    ProgresAppView()
}
