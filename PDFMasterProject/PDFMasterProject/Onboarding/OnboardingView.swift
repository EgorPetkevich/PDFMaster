//
//  OnboardingView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 01.12.2024.
//
import SwiftUI
import StoreKit
import SUINavigation

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.currentIndex) {
                ForEach(0..<viewModel.onboardingData.count, id: \.self) { index in
                    Image(viewModel.onboardingData[index].imageName)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .tag(index)
                        .transition(.slide)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            .animation(.easeInOut, value: viewModel.currentIndex)
            
            VStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 24) {
                    Text(viewModel.onboardingData[viewModel.currentIndex].title)
                        .font(.custom("Poppins-Bold", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "2E3A59"))
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.onboardingData[viewModel.currentIndex].description)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color(hex: "2E3A59"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                   
                        HStack(spacing: 8) {
                            ForEach(0..<viewModel.pagesCount + 1, id: \.self) { index in
                                Circle()
                                    .fill(index == viewModel.currentIndex ? Color.red : Color.gray.opacity(0.4))
                                    .frame(width: 8, height: 8)
                            }
                        
                    }
                    
                    LazyVStack(spacing: 0) {
                            BouncingButton(title: viewModel.currentIndex == 0 ? "Start" : "Next") {
                                 if viewModel.currentIndex == 2 {
                                    viewModel.closeOnboarding()
                                } else {
                                    viewModel.nextStep()
                                    
                                }
                            }
                            .padding(.horizontal)
                        
                        LazyHStack(spacing: 2) {
                            Text("Terms of Service")
                                .font(.custom("Gilroy-Light", size: 12))
                                .foregroundColor(Color(hex: "2E3A59"))
                                .opacity(viewModel.opacityLevel)
                                .onTapGesture {
                                    print("Terms of Service")
                                }
                            Text("and")
                                .font(.custom("Gilroy-Light", size: 12))
                                .foregroundColor(Color(hex: "2E3A59").opacity(0.5))
                                .opacity(viewModel.opacityLevel)
                            Text("Privacy Policy")
                                .font(.custom("Gilroy-Light", size: 12))
                                .foregroundColor(Color(hex: "2E3A59"))
                                .opacity(viewModel.opacityLevel)
                                .onTapGesture {
                                    print("Privacy Policy")
                                }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.top, 24)
                .background(
                    Color.white.cornerRadius(32)
                ).onAppear {
                    viewModel.setPageCounter()
                }
            }
            .ignoresSafeArea()
            
        }
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}


