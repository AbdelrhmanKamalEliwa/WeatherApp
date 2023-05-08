//
//  CacheManagerContract.swift
//
//  Created by Abdelrhman Eliwa.
//

protocol CacheManagerContract {
    var userDefaults: UserDefaultsManagerContract { get }
    
    var forecastHistory: [ForecastHistoryItem] { get set }
    var currentWeatherHistory: [CurrentWeatherHistoryItem] { get set }
}
