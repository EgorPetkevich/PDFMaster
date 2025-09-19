//
//  TrialToggleView.swift
//  PDFMaster
//
//  Created by George Popkich on 4.02.25.
//

import SwiftUI

struct TrialToggleView: View {
    @State private var isOn: Bool = false
    var toggleState: ((Bool) -> Void)?

    var body: some View {
        HStack {
            Text("I want my free Trial")
                .font(.poppinsFont(size: 16, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(CustomToggleStyle())
                .onChange(of: isOn) { newValue in
                    toggleState?(newValue)
                }
                
            
        }
        .padding(.top, 12)
        .padding(.bottom, 12)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.red, lineWidth: 2)
        )
        .frame(height: 55)
        .padding(.horizontal)
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [
                    Color(hex: "FF8C8C"),
                    Color(hex: "E30010")],
                                           startPoint: .top,
                                           endPoint: .bottom))
                .frame(width: 50, height: 30)
                .opacity(configuration.isOn ? 1 : 0.5)
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
                .offset(x: configuration.isOn ? 10 : -10)
                .animation(.easeInOut, value: configuration.isOn)
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}


#Preview {
    TrialToggleView() { toggleState in
        print(toggleState)
    }
}
