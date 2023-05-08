//
//  GetForecastUseCaseContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

protocol GetForecastUseCaseContract {
    func excute(
        latitude: Double,
        longitude: Double,
        units: WeatherUnits,
        isCurrentLocation: Bool
    ) -> Observable<Result<ForecastResponse, BaseError>>
    
    func excute(
        cityName: String?,
        zipCode: String?,
        units: WeatherUnits
    ) -> Observable<Result<ForecastResponse, BaseError>>
    
    func excute(
        units: WeatherUnits,
        fromCache: Bool
    ) -> Observable<Result<ForecastResponse, BaseError>>
}

extension GetForecastUseCaseContract {
    func excute(
        cityName: String? = nil,
        zipCode: String? = nil,
        units: WeatherUnits
    ) -> Observable<Result<ForecastResponse, BaseError>> {
        
        self.excute(cityName: cityName, zipCode: zipCode, units: units)
    }
}
