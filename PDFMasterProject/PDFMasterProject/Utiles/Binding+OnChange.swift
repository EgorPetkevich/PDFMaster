//
//  Binding+OnChange.swift
//  PDFMaster
//
//  Created by George Popkich on 21.02.25.
//

import SwiftUI

extension Binding {
    @MainActor
    @discardableResult
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
