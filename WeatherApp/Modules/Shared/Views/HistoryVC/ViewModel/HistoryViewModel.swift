//
//  HistoryViewModel.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift
import RxRelay

final class HistoryViewModel: BaseViewModel {
    
    private(set) var dataSourceSubject: PublishSubject<[HistoryItem]> = .init()
    private let cacheManager: CacheManagerContract
    private let isCurrentWeather: Bool
    
    init(
        isCurrentWeather: Bool,
        cacheManager: CacheManagerContract = CacheManager.shared
    ) {
        self.isCurrentWeather = isCurrentWeather
        self.cacheManager = cacheManager
        
        super.init()
    }
    
    func loadHistory() {
        dataSourceSubject
            .onNext(
                isCurrentWeather ? cacheManager.currentWeatherHistory : cacheManager.forecastHistory
            )
    }
}
