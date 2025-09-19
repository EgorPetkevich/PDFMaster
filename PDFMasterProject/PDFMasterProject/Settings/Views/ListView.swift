//
//  SettingsListView.swift
//  PDFMaster
//
//  Created by George Popkich on 1.02.25.
//

import SwiftUI

struct SettingsListView: View {
    
    var settingsOptions:  [SettingsOptions.Settings]
    var rowDidSelect: ((SettingsOptions.Settings) -> Void)?
    
    var body: some View {
        List {
            ForEach(settingsOptions, id: \.self) { row in
                SettingsRow(icon: row.icon, title: row.title) {
                    rowDidSelect?(row)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .scrollDisabled(true)
        .listRowSpacing(-12)
        .background(Color.clear)
        .padding(.horizontal, -16)
        .padding(.top, -32)
    }
    
   
    
}

#Preview {
    SettingsListView(settingsOptions: [SettingsOptions.Settings.contact])
}
