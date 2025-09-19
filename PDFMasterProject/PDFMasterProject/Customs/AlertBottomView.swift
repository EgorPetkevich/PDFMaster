//
//  AlertBottomView.swift
//  PDFMaster
//
//  Created by George Popkich on 10.02.25.
//

import SwiftUI

struct AlertBottomView: View {
    private enum Constants {
        static let cancelButtonText: String = "Cancel"
        static let okButtonText: String = "Got it"
    }
    @Binding var isPresented: Bool
    @Binding var convertComplete: Bool
    @Binding var progress: CGFloat
    @State var titleOnCompletion: String
    
    let titleText: String
    let subTitleText: String

    var cancelButtonDidTap: () -> Void
    
    var body: some View {
        ZStack {
            if isPresented && !convertComplete {
                VStack() {
                    VStack {
                        Text(titleText)
                            .font(.poppinsFont(size: 24.24,
                                               weight: .semibold))
                            .foregroundColor(.appBlack)
                            .padding(.top, 24)
                        
                        Text(subTitleText)
                            .font(.poppinsFont(size: 13))
                            .foregroundColor(.appBlack)
                            .padding(.bottom, 24)
                        
                        ProgressBar(progress: $progress)
                            .padding(.horizontal)
                            .frame(height: 8)
                            .padding(.bottom, 24)
                    }.background(RoundedRectangle(cornerRadius: 34)
                        .fill(Color.white))
                    .padding(.bottom, 16)
                    
                    Button(action: {
                        isPresented = false
                        cancelButtonDidTap()
                    }) {
                        Text(Constants.cancelButtonText)
                            .frame(height: 56)
                            .font(.poppinsFont(size: 16,
                                               weight: .semibold))
                            .foregroundColor(.appBlack)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 34)
                                .fill(Color.white))
                            .padding(.bottom)
                    }
                }
                .background(Color.clear)
                .cornerRadius(24)
            }
            if isPresented && convertComplete {
                VStack() {
                    VStack {
                        Image.ImageConverter.completeIcon
                            .frame(width: 72, height: 72)
                            .padding(.top, 24)
                        Text(titleOnCompletion)
                            .font(.poppinsFont(size: 20,
                                               weight: .semibold))
                            .foregroundColor(.appBlack)
                            .padding(.top, 10)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 28)
                        
                    }.background(RoundedRectangle(cornerRadius: 34)
                        .fill(Color.white))
                    .padding(.bottom, 16)
                    
                    
                    Button(action: { 
                        isPresented = false
                    }) {
                        Text(Constants.okButtonText)
                            .frame(height: 56)
                            .font(.poppinsFont(size: 16,
                                               weight: .semibold))
                            .foregroundColor(.appWhite)
                            .frame(maxWidth: .infinity)
                            
                            
                            .background(RoundedRectangle(cornerRadius: 34)
                                .fill(LinearGradient(colors: [
                                    Color(hex: "22EF75"),
                                    Color(hex: "00C650")],
                                    startPoint: .top,
                                    endPoint: .bottom)))
                            .padding(.bottom)
                    }
                }
                .background(Color.clear)
                .cornerRadius(24)
            }
        }
        
    }
}

//#Preview {
//    AlertBottomView(
//        isPresented: .constant(true),
//        convertComplete: true, 
//        progress: 20,
//        titleOnCompletion: "Files succesfully merged",
//        titleText: "File Converting...",
//        subTitleText: "It would take some time")
//}


//struct BlurView: UIViewRepresentable {
//    var style: UIBlurEffect.Style
//
//    func makeUIView(context: Context) -> UIVisualEffectView {
//        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
//        return blurView
//    }
//
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
//}
