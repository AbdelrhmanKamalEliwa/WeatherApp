//
//  GetCurrentWeatherUseCaseContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

protocol GetCurrentWeatherUseCaseContract {
    func excute(
        latitude: Double,
        longitude: Double,
        units: WeatherUnits,
        isCurrentLocation: Bool
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>>
    
    func excute(
        cityName: String?,
        zipCode: String?,
        units: WeatherUnits
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>>
    
    func excute(
        units: WeatherUnits
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>>
}

extension GetCurrentWeatherUseCaseContract {
    func excute(
        cityName: String? = nil,
        zipCode: String? = nil,
        units: WeatherUnits
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>> {
        
        self.excute(cityName: cityName, zipCode: zipCode, units: units)
    }
}
