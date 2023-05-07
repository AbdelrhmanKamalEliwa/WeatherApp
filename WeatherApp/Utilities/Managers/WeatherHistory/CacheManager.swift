//
//  CacheManager.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    
    private init() { }
}

// MARK: - CacheManagerContract
//
extension CacheManager: CacheManagerContract {
    var userDefaults: UserDefaultsManagerContract {
        UserDefaultsManager.shared
    }
    
    var currentWeatherHistory: [HistoryItem] {
        get {
            let chachedData = userDefaults.getValue(for: .currentWeatherHistory) as? String
            let decodedData = [HistoryItem].decode(chachedData) ?? []
            if decodedData.count > 10 {
                return Array(decodedData[0...9])
            }
            return decodedData
        } set {
            guard let newValue = newValue.json, !newValue.isEmpty else { return }
            userDefaults.set(value: newValue, for: .currentWeatherHistory)
        }
    }
    
    var forecastHistory: [HistoryItem] {
        get {
            let chachedData = userDefaults.getValue(for: .forecastHistory) as? String
            return [HistoryItem].decode(chachedData)?.reversed() ?? []
        } set {
            guard let newValue = newValue.json, !newValue.isEmpty else { return }
            userDefaults.set(value: newValue, for: .forecastHistory)
        }
    }
}
