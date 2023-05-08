//
//  CurrentWeatherRepositoryContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

protocol CurrentWeatherRepositoryContract {
    func getCurrentWeather<T: Encodable>(
        using requestModel: T, forItem searchType: SearchItem, fromCache: Bool
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>>
}
