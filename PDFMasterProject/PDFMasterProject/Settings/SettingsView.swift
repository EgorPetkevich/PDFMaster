//
//  SettingsView.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 27.11.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: SettingsViewModel
    @StateObject private var alertService: AlertService = .instance
    @AppStorage(UDManager.Keys.isPremium.rawValue) var isPremium: Bool = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                }
                Text("Settings")
                    .font(.custom("Poppins-SemiBold", size: 20))
            }
            
            if !isPremium {
                UnlockPremiumRow().onTapGesture {
                    viewModel.showPaywall = true
                }
            }
            
            SettingsListView(settingsOptions: viewModel.settingsOptions) { selectedRow in
                viewModel.rowDidSelect(selectedRow)
            }
        }
        .background(Color(hex: "#F2F5FF"))
        .offset(x: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.width > 0 {
                        dragOffset = gesture.translation.width
                    }
                }
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                    withAnimation {
                        dragOffset = 0
                    }
                }
        )
        .sheet(isPresented: $viewModel.showMailView) {
            MailView()
        }
        .sheet(isPresented: $viewModel.isSharing) {
            ShareController(items: [AppConfig.share])
        }
        .alert(item: $alertService.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message ?? ""),
                primaryButton: alertItem.primaryButton ?? .default(Text("OK")),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $viewModel.showPaywall) {
            if viewModel.showReviewPaywall() {
                ReviewPaywallView(viewModel: ReviewPaywallViewModel())
            } else {
                ProdPaywallView(viewModel: ProdPaywallViewModel(), showPageContorl: false)
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}

