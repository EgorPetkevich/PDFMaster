//
//  Text+Fonst.swift
//  PDFMaster
//
//  Created by George Popkich on 4.02.25.
//

import SwiftUI
import SwiftUI

extension Font {
    
    private enum Weights: String {
        case regular = "Regular"
        case medium = "Medium"
        case semibold = "SemiBold"
        case bold = "Bold"
    }
    
    private static func poppinsWeight(for weight: Font.Weight) -> String {
        switch weight {
        case .bold:
            return Weights.bold.rawValue
        case .semibold:
            return Weights.semibold.rawValue
        case .medium:
            return Weights.medium.rawValue
        default:
            return Weights.regular.rawValue
        }
    }

    static func poppinsFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom("Poppins-\(poppinsWeight(for: weight))", size: size)
    }
    
    static func gilroy(size: CGFloat) -> Font {
        Font.custom("Gilroy-Light", size: size)
    }
    
}

