//
//  SKProduct+Localized.swift
//  PDFMaster
//
//  Created by George Popkich on 1.02.25.
//

import StoreKit

extension SKProduct {
    
    var localizedCurrencyPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
    
}
