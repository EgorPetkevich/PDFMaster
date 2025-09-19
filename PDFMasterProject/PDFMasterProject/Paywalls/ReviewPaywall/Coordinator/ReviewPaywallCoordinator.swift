//
//  ReviewPaywallCoordinator.swift
//  PDFMaster
//
//  Created by George Popkich on 4.02.25.
//

import SwiftUI
import SUINavigation

final class ReviewPaywallCoordinator {
    
    var dismiss: (() -> Void)?
    
    @MainActor static func make() -> ReviewPaywallView {
        let viewModel = ReviewPaywallViewModel()
        let view = ReviewPaywallView(viewModel: viewModel)
       
        return view
    }
    
}
