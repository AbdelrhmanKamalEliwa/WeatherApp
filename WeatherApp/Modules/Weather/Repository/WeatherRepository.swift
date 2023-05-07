//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

final class WeatherRepository: DisposeObject {
    let service: APIServiceContract
    var cacheManager: CacheManagerContract?
    
    init(
        service: APIServiceContract = APIService.shared,
        cacheManager: CacheManagerContract? = CacheManager.shared
    ) {
        self.service = service
        self.cacheManager = cacheManager
    }
}

