//
//  UDManager.swift
//  PDFMaster
//
//  Created by George Popkich on 1.02.25.
//

import Foundation

final class UDManager {
    
    enum Keys: String {
        case createFileDirectory = "createFileDirectory"
        case reviewWasShown = "reviewWasShown"
        case prodWasShow = "prodWasShow"
        case timer = "timer"
        case isPremium = "isPremium"
        case isReview = "isReview"
    }
    
    private static var ud: UserDefaults = .standard
    
    private init() {}
    
    static func setValue(forKey key: Keys, value: Bool) {
        ud.setValue(value, forKey: key.rawValue)
    }
    
    static func getValue(forKey key: Keys) -> Bool {
        return ud.bool(forKey: key.rawValue)
    }
    
    static func setAppStatus(isPremium value: Bool) {
        ud.set(value, forKey: Keys.isPremium.rawValue)
    }
    
    static func isPremium() -> Bool {
        getValue(forKey: .isPremium)
    }
    
    
    static func setTimerValue(_ timer: Int) {
        ud.set(timer, forKey: Keys.timer.rawValue)
    }
    
    static func getTimerValue() -> Int {
        if let value = ud.value(forKey: Keys.timer.rawValue) as? Int {
            return value
        }
        return 3
    }
}
