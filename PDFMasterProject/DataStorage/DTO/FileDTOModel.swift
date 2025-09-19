//
//  FileDTOModel.swift
//  DataStorage
//
//  Created by George Popkich on 14.02.25.
//

import Foundation

public struct FileDTOModel: Codable {
    public var id: String
    public var date: Date
    public var iconName: String
    public var name: String
    public var size: String
    public var type: String
    public var url: String
    
    public init(id: String = UUID().uuidString,
         date: Date = .now,
         iconName: String = "mainIcon",
         name: String,
         size: String,
         type: String,
         url: String) {
        self.id = id
        self.date = date
        self.iconName = iconName
        self.name = name
        self.size = size
        self.type = type
        self.url = url
    }
}
