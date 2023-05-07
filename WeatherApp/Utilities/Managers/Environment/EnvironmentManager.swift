//
//  EnvironmentManager.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

final class EnvironmentManager {
    static let shared = EnvironmentManager()
    
    private var infoDict: [String: Any]
    
    private init() {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Couldn't find plist file")
        }
        
        infoDict = dict
    }
}

// MARK: - EnvironmentManagerContract
//
extension EnvironmentManager: EnvironmentManagerContract {
    typealias Key = UserDefined
    
    /// Method to fetch String value from Info.plist
    /// - Parameter key: Key to fetch from Info.plist
    /// - Returns: Value fetched from Info.plist
    func string(key: Key) -> String {
        (self.infoDict[key.rawValue] as? String).value
    }
    
    /// Method to fetch Boolean value from Info.plist
    /// - Parameter key: Key to fetch from Info.plist
    /// - Returns: Value fetched from Info.plist
    func boolean(key: Key) -> Bool {
        (self.infoDict[key.rawValue] as? Bool).value
    }
    
    /// Method to fetch Dictionary value from Info.plist
    /// - Parameter key: Key to fetch from Info.plist
    /// - Returns: Value fetched from Info.plist
    func dictionary(key: Key) -> [String : Any] {
        (self.infoDict[key.rawValue] as? [String: Any]).value
    }
}
