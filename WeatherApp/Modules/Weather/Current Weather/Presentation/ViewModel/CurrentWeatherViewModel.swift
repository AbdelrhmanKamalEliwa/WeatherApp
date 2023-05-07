//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift
import RxRelay

final class CurrentWeatherViewModel: CurrentWeatherViewModelContract {
    
    enum Navigation {
        case forecast(viewModel: BaseViewModel)
        case history(viewModel: HistoryViewModel)
    }
    
    enum SearchType: Equatable {
        case cityName
        case zipcode
        case coordinates
        case currentLocation(coordinates: String)
    }
    
    var firstTextFieldRelay: BehaviorRelay<String> = .init(value: "")
    var secondTextFieldRelay: BehaviorRelay<String> = .init(value: "")
    
    private let currentWeatherUseCase: GetCurrentWeatherUseCaseContract
    private(set) var navigationSubject: PublishSubject<Navigation> = .init()
    private(set) var weatherSubject: PublishSubject<CurrentWeatherRepresentableModelContract> = .init()
    private(set) var dataSourceSubject: PublishSubject<[WeatherRepresentableModelContract]> = .init()
    private(set) var searchTypeRelay: BehaviorRelay<SearchType?> = .init(value: nil)
    private(set) var tempTypeRelay: BehaviorRelay<WeatherUnits> = .init(value: .celsius)
    
    private var weatherDataSource: [WeatherRepresentableModelContract] = [] {
        didSet {
            dataSourceSubject.onNext(weatherDataSource)
        }
    }
    
    init(currentWeatherUseCase: GetCurrentWeatherUseCaseContract = GetCurrentWeatherUseCase()) {
        self.currentWeatherUseCase = currentWeatherUseCase
    }
    
    func didLoad() {
        getCurrentWeatherByCurrentLocation()
    }
    
    func didTapHistoryButton() {
        navigationSubject.onNext(.history(viewModel: HistoryViewModel(isCurrentWeather: true)))
    }
    
    func didTapForecastButton() {
        navigationSubject.onNext(.forecast(viewModel: BaseViewModel()))
    }
    
    func search() {
        guard let searchType = searchTypeRelay.value else { return }
        
        switch searchType {
        case .cityName:
            getCurrentWeatherByCityName()
            
        case .zipcode:
            getCurrentWeatherByZipcode()
            
        case .coordinates:
            getCurrentWeatherByCoordinates()
            
        case .currentLocation:
            getCurrentWeatherByCurrentLocation()
        }
    }
    
    func didTapTempTypeButton() {
        tempTypeRelay.accept(tempTypeRelay.value == .celsius ? .fahrenheit : .celsius)
        search()
    }
    
    func didTapSearchFiltersButton() {
        alertItemRelay.accept(
            .init(
                title: "Select search type",
                message: nil,
                style: .actionSheet,
                actions: [
                    .init(title: "City name", style: .default, action: { [weak self] in
                        guard let self = self else { return }
                        self.searchTypeRelay.accept(.cityName)
                    }),
                    .init(title: "Zip code", style: .default, action: { [weak self] in
                        guard let self = self else { return }
                        self.searchTypeRelay.accept(.zipcode)
                    }),
                    .init(title: "Coordinates", style: .default, action: { [weak self] in
                        guard let self = self else { return }
                        self.searchTypeRelay.accept(.coordinates)
                    }),
                    .init(title: "Current location", style: .default, action: { [weak self] in
                        guard let self = self else { return }
                        self.getCurrentWeatherByCurrentLocation()
                    }),
                    .init(title: "Cancel", style: .cancel, action: nil)
                ]
            )
        )
    }
}

// MARK: - PRIVARE METHODS
//
private extension CurrentWeatherViewModel {
    func getCurrentWeatherByCoordinates() {
        guard firstTextFieldRelay.value.isNotEmpty, firstTextFieldRelay.value.isNotEmpty else { return }
        guard let lat = Double(firstTextFieldRelay.value), let long = Double(firstTextFieldRelay.value) else {
            alertItemRelay.accept(
                .init(
                    title: "Validation Error",
                    message: "You should enter valid city name",
                    style: .alert,
                    actions: [.init(title: "Done", action: nil)]
                )
            )
            return
        }
        
        getCurrentWeatherByCoordinates(latitude: lat, longitude: long)
    }
    
    func getCurrentWeatherByZipcode() {
        guard firstTextFieldRelay.value.isNotEmpty else { return }
        guard firstTextFieldRelay.value.isValidZipCode else {
            alertItemRelay.accept(
                .init(
                    title: "Validation Error",
                    message: "You should enter valid zip code",
                    style: .alert,
                    actions: [.init(title: "Done", action: nil)]
                )
            )
            return
        }
        
        getCurrentWeatherByInfo(cityName: firstTextFieldRelay.value)
    }
    
    func getCurrentWeatherByCityName() {
        guard firstTextFieldRelay.value.isNotEmpty else { return }
        guard firstTextFieldRelay.value.isValidCityName else {
            alertItemRelay.accept(
                .init(
                    title: "Validation Error",
                    message: "You should enter valid city name",
                    style: .alert,
                    actions: [.init(title: "Done", action: nil)]
                )
            )
            return
        }
        
        getCurrentWeatherByInfo(cityName: firstTextFieldRelay.value)
    }
    
    func getCurrentWeatherByCurrentLocation() {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        currentWeatherUseCase
            .excute(units: tempTypeRelay.value)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.stateRelay.accept(.successful)
                
                switch result {
                case .success(let data):
                    self.weatherSubject.onNext(data)
                    self.weatherDataSource = data.weather ?? []
                    self.searchTypeRelay.accept(.currentLocation(coordinates: "\(data.coord.lat) \(data.coord.lon)"))
                    
                case .failure(let error):
                    self.alertItemRelay.accept(.init(message: error.message))
                }
                
            } onError: { [weak self] error in
                guard let self = self else { return }
                guard let error = error as? BaseError else { return }
                self.alertItemRelay.accept(.init(message: error.message))
            }
            .disposed(by: disposeBag)
        
    }
    
    func getCurrentWeatherByCoordinates(latitude: Double, longitude: Double) {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        currentWeatherUseCase
            .excute(
                latitude: latitude,
                longitude: longitude,
                units: tempTypeRelay.value,
                isCurrentLocation: !(searchTypeRelay.value == .coordinates)
            )
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.stateRelay.accept(.successful)
                
                switch result {
                case .success(let data):
                    self.weatherSubject.onNext(data)
                    self.weatherDataSource = data.weather ?? []
                    
                case .failure(let error):
                    self.alertItemRelay.accept(.init(message: error.message))
                }
                
            } onError: { [weak self] error in
                guard let self = self else { return }
                guard let error = error as? BaseError else { return }
                self.alertItemRelay.accept(.init(message: error.message))
            }
            .disposed(by: disposeBag)
    }
    
    
    func getCurrentWeatherByInfo(cityName: String? = nil, zipcode: String? = nil) {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        currentWeatherUseCase
            .excute(
                cityName: cityName,
                zipCode: zipcode,
                units: tempTypeRelay.value
            )
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.stateRelay.accept(.successful)
                
                switch result {
                case .success(let data):
                    self.weatherSubject.onNext(data)
                    self.weatherDataSource = data.weather ?? []
                    
                case .failure(let error):
                    self.alertItemRelay.accept(.init(message: error.message))
                }
                
            } onError: { [weak self] error in
                guard let self = self else { return }
                guard let error = error as? BaseError else { return }
                self.alertItemRelay.accept(.init(message: error.message))
            }
            .disposed(by: disposeBag)
    }
}
