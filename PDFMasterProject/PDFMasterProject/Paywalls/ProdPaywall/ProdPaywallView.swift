//
//  ProdPaywallView.swift
//  PDFMaster
//
//  Created by George Popkich on 5.02.25.
//

import SwiftUI

struct ProdPaywallView: View {
    
    private enum Constants {
        static let titleText: String = "Unlock the power \n of PDF Converter app"
        static let termsText: String = "Terms of Service"
        static let privacyText: String = "Terms of Service"
        static let restorText: String = "Restore"
        
        static func subTitleText(price: String) -> String {
            "Get a tool for work with scanner & the ability to save files in PDF just for \(price) per week"
        }
        static func subButtonTitle(price: String) -> String {
            "Start to continue"
        }
    }
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: ProdPaywallViewModel
    @StateObject private var alertService: AlertService = .instance
    @State var isShowingLast: Bool = false
    
    let showPageContorl: Bool
    
    var body: some View {
        
        ZStack {
            
            Image.Paywall.reviewBack
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    if viewModel.showCrossButton {
                        Button(action: {
                            viewModel.crossButtonDidTap()
                        }) {
                            Image.Paywall.cross
                                .resizable()
                                .foregroundColor(.appBlack)
                                .frame(width: 26, height: 26)
                        }
                    }
                    Spacer()
                    Button {
                        Task {
                            await viewModel.restorButtonDidTap()
                        }
                        
                    } label: {
                        Text(Constants.restorText)
                            .font(.poppinsFont(size: 12,
                                               weight: .medium))
                            .foregroundColor(.appBlack)
                    }
                    
                }
                .padding(.horizontal, 22)
                .padding(.top, 70)
                
                Spacer()

                VStack {
                    Text(Constants.titleText)
                        .font(.poppinsFont(size: 30, weight: .bold))
                        .foregroundColor(.appBlack)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.top, 24)
                        .padding(.bottom, 10)
                        

                    Text(Constants.subTitleText(price: viewModel.getPrice()))
                        .font(.poppinsFont(size: 14))
                        .foregroundColor(.appBlack)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    
                    if showPageContorl {
                        HStack(spacing: 8) {
                            ForEach(0..<5, id: \.self) { index in
                                Circle()
                                    .fill(index == 3 ? Color.red : Color.gray.opacity(0.4))
                                    .frame(width: 8, height: 8)
                            }
                        }.padding(.bottom, 20)
                    }
                  

                    BouncingButton(title: Constants.subButtonTitle(price: viewModel.getPrice())) {
                        Task {
                            await viewModel.subButtonDidTap()
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    
                    HStack() {
                        Text(Constants.termsText)
                            .font(.gilroy(size: 12))
                            .foregroundColor(.appDarkGrayText)
                            .onTapGesture {
                                viewModel.termsDidTap()
                            }
                        Text("and")
                            .font(.gilroy(size: 12))
                            .foregroundColor(.appDarkGrayText).opacity(0.5)
                           
                        Text(Constants.privacyText)
                            .font(.gilroy(size: 12))
                            .foregroundColor(.appDarkGrayText)
                            .onTapGesture {
                                viewModel.privacyDidTap()
                            }
                    }
                    .padding(.bottom, 30)
                }
                
                .padding(.bottom)
                
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.appWhite)
                )
                
            }.ignoresSafeArea()
            
        }
        .alert(item: $alertService.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message ?? ""),
                primaryButton: alertItem.primaryButton ?? .default(Text("OK")),
                secondaryButton: .cancel()
            )
        }
        .onChange(of: viewModel.dismissView) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
    
}

#Preview {
    ProdPaywallView(viewModel: ProdPaywallViewModel(), 
                    showPageContorl: true)
}
