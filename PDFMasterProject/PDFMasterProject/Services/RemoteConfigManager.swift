//
//  RemoteConfigManager.swift
//  PDFMaster
//
//  Created by Альберт Ражапов on 05.12.2024.
//

import FirebaseRemoteConfig

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
        fetchRemoteConfig()
    }
    
    func fetchRemoteConfig() {
        remoteConfig.fetchAndActivate { status, error in
            if let error = error {
                print("Failed to fetch remote config: \(error)")
            } else {
                print("Remote config fetched successfully.")
            }
        }
    }
    
    func getBoolValue(forKey key: String) -> Bool {
        return remoteConfig[key].boolValue
    }
    
    func getDoubleValue(forKey key: String) -> Double {
        return remoteConfig[key].numberValue.doubleValue
    }
    
    func getStringValue(forKey key: String) -> String {
        return remoteConfig[key].stringValue
    }
}
