//
//  EnvironmentManagerContract.swift
//
//  Created by Abdelrhman Eliwa.
//

protocol EnvironmentManagerContract {
    associatedtype Key
    /// Method to fetch String value from Info.plist
    /// - Parameter key: Key to fetch from Info.plist
    /// - Returns: Value fetched from Info.plist
    func string(key: Key) -> String
    
    /// Method to fetch Boolean value from Info.plist
    /// - Parameter key: Key to fetch from Info.plist
    /// - Returns: Value fetched from Info.plist
    func boolean(key: Key) -> Bool
    
    /// Method to fetch Dictionary value from Info.plist
    /// - Parameter key: Key to fetch from Info.plist
    /// - Returns: Value fetched from Info.plist
    func dictionary(key: Key) -> [String: Any]
}
