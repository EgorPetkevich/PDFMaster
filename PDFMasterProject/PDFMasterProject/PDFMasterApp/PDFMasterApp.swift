//
//  PDFMasterApp.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 20.11.2024.
//

import SwiftUI
import ApphudSDK
import FirebaseCore
import DataStorage

@main
struct PDFMasterApp: App {
    let persistenceContainer = PersistenceController.shared
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @AppStorage("isPremium") var isPremium: Bool = true
    @StateObject private var apphudService = ApphudService.instance
    @State private var showMainView = false
    
    init() {
//        Apphud.start(apiKey: AppConfig.apphudKEY)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isPremium || showMainView || apphudService.paywallWasShown {
                    MainView(apphudService: apphudService,
                             viewModel: MainViewModel())
                        .environment(\.managedObjectContext,
                                      persistenceContainer.container.viewContext)
                        .preferredColorScheme(.light)
                } else if isOnboarding {
                    OnboardingView(viewModel: OnboardingViewModel())
                        .onDisappear {
                            isOnboarding = false
                            if apphudService.isPremium {
                                showMainView = true
                            }
                        }
                } else if
                    let paywallView = apphudService.paywallView {
                        paywallView
                    
                } else {
                    ProgresAppView()
                }
            }
            .onAppear {
                isPremium = apphudService.isPremium
            }
        }
    }
}
