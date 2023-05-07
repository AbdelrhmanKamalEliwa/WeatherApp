//
//  CacheManagerContract.swift
//
//  Created by Abdelrhman Eliwa.
//

protocol CacheManagerContract {
    var userDefaults: UserDefaultsManagerContract { get }
    
    var forecastHistory: [HistoryItem] { get set }
    var currentWeatherHistory: [HistoryItem] { get set }
}
