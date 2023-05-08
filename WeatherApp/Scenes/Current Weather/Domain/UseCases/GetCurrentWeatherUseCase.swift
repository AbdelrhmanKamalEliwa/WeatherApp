//
//  GetCurrentWeatherUseCase.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

final class GetCurrentWeatherUseCase: GetCurrentWeatherUseCaseContract {
    private let repository: CurrentWeatherRepositoryContract
    private let locationManager: LocationManagerContract
    
    init(
        repository: CurrentWeatherRepositoryContract = CurrentWeatherRepository(),
        locationManager: LocationManagerContract = LocationManager.shared
    ) {
        self.repository = repository
        self.locationManager = locationManager
    }
    
    func excute(
        latitude: Double,
        longitude: Double,
        units: WeatherUnits,
        isCurrentLocation: Bool
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>> {
        struct RequestModel: GetCurrentWeatherRequestModelContract {
            var lat: Double
            var lon: Double
            var units: WeatherUnits
        }
        
        let requestModel = RequestModel(lat: latitude, lon: longitude, units: units)
        return repository.getCurrentWeather(using: requestModel, forItem: isCurrentLocation ? .currentLocation : .coordinates, fromCache: false)
    }
    
    func excute(
        cityName: String?,
        zipCode: String?,
        units: WeatherUnits
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>> {
        struct RequestModel: GetCurrentWeatherSearchRequestModelContract {
            var q: String
            var units: WeatherUnits
        }
        
        var searchItem: SearchItem = .cityName
        
        let q: String = {
            if let cityName = cityName {
                return cityName
                
            } else {
                searchItem = .zipCode
                return zipCode ?? ""
            }
        }()
        
        let requestModel = RequestModel(q: q, units: units)
        return repository.getCurrentWeather(using: requestModel, forItem: searchItem, fromCache: false)
    }
    
    func excute(
        units: WeatherUnits, fromCache: Bool
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>> {
        
        let authorization = locationManager.requestAuthorization()
        
        switch authorization {
        case .success:
            let currentLocation = locationManager.getCurrentLocation()
            return getCurrentWeatherByCurrentLocation(using: currentLocation, and: units, fromCache: fromCache)
            
        case .failure(let error):
            return .create { observer in
                observer.onNext(.failure(error))
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}

// MARK: - PRIVATE METHODS
//
private extension GetCurrentWeatherUseCase {
    func getCurrentWeatherByCurrentLocation(
        using data: Result<LocationCoordinate, BaseError>,
        and units: WeatherUnits,
        fromCache: Bool
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>> {
        
        switch data {
        case .success(let coordinates):
            
            struct RequestModel: GetCurrentWeatherRequestModelContract {
                var lat: Double
                var lon: Double
                var units: WeatherUnits
            }
            
            let requestModel = RequestModel(lat: coordinates.latitude, lon: coordinates.longitude, units: units)
            return repository.getCurrentWeather(using: requestModel, forItem: .currentLocation, fromCache: fromCache)
            
        case .failure(let error):
            return .create { observer in
                observer.onNext(.failure(error))
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}
