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
    
    var currentWeatherHistory: [CurrentWeatherHistoryItem] {
        get {
            let chachedData = userDefaults.getValue(for: .currentWeatherHistory) as? String
            let decodedData = [CurrentWeatherHistoryItem].decode(chachedData) ?? []
            if decodedData.count > 10 {
                return Array(decodedData[0...9])
            }
            return decodedData
        } set {
            guard let newValue = newValue.json, !newValue.isEmpty else { return }
            userDefaults.set(value: newValue, for: .currentWeatherHistory)
        }
    }
    
    var forecastHistory: [ForecastHistoryItem] {
        get {
            let chachedData = userDefaults.getValue(for: .forecastHistory) as? String            
            let decodedData = [ForecastHistoryItem].decode(chachedData) ?? []
            if decodedData.count > 5 {
                return Array(decodedData[0...4])
            }
            return decodedData
        } set {
            guard let newValue = newValue.json, !newValue.isEmpty else { return }
            userDefaults.set(value: newValue, for: .forecastHistory)
        }
    }
}
