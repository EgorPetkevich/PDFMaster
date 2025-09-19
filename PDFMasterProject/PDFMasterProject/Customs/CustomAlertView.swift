//
//  CustomAlertView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 29.11.2024.
//


import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    let takeShotAction: () -> Void
    let selectPictureAction: () -> Void

    var body: some View {
        ZStack {
            if isPresented {
                VStack() {
                    VStack {
                        Text("Select how to upload file")
                            .font(.custom("Poppins-SemiBold", size: 24))
                            .foregroundColor(Color(hex: "2E3A59"))
                            .padding(24)
                        
                        Button(action: takeShotAction ) {
                            Text("Take a shot")
                                .frame(height: 56)
                                .font(.custom("Poppins-SemiBold", size: 16))
                                .foregroundColor(Color(hex: "2E3A59"))
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 34)
                                    .fill(Color(hex: "EEF2FF")))
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        
                        Button(action: selectPictureAction) {
                            Text("Select from files")
                                .frame(height: 56)
                                .font(.custom("Poppins-SemiBold", size: 16))
                                .foregroundColor(Color(hex: "2E3A59"))
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 34)
                                    .fill(Color(hex: "EEF2FF")))
                                .padding(.horizontal)
                                .padding(.bottom, 24)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.vertical)
                        
                    
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                            .frame(height: 56)
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .foregroundColor(Color(hex: "2E3A59"))
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 34)
                                .fill(Color.white))
                            .padding(.bottom)
                    }
                }
                .background(Color.clear)
                .cornerRadius(24)
            }
        }
    }
}

#Preview {
    CustomAlertView(
        isPresented: .constant(true),
        takeShotAction: {},
        selectPictureAction: {})
}


struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
