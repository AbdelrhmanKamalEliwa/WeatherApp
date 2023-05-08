//
//  ForecastRepositoryContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

protocol ForecastRepositoryContract {
    func getForecast<T: Encodable>(
        using requestModel: T, forItem searchType: SearchItem, fromCache: Bool
    ) -> Observable<Result<ForecastResponse, BaseError>>
}
