//
//  DashboardViewModel.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift
import RxRelay

final class DashboardViewModel: DashboardViewModelContract {
    // MARK: - ENUMS
    //
    enum Navigation {
        case forecast(viewModel: ForecastViewModel)
        case currentWeather(viewModel: CurrentWeatherViewModelContract)
    }
    
    // MARK: - PROPERTIES
    //
    private let currentWeatherUseCase: GetCurrentWeatherUseCaseContract
    private let forecastUseCase: GetForecastUseCaseContract
    
    private(set) var navigationSubject: PublishSubject<Navigation> = .init()
    private(set) var weatherSubject: PublishSubject<CurrentWeatherRepresentableModelContract> = .init()
    private(set) var dataSourceSubject: PublishSubject<[WeatherRepresentableModelContract]> = .init()
    
    private var weatherDataSource: [WeatherRepresentableModelContract] = [] {
        didSet {
            dataSourceSubject.onNext(weatherDataSource)
        }
    }
    
    // MARK: - LIFECYCLE
    //
    init(
        currentWeatherUseCase: GetCurrentWeatherUseCaseContract = GetCurrentWeatherUseCase(),
        forecastUseCase: GetForecastUseCaseContract = GetForecastUseCase()
    ) {
        self.currentWeatherUseCase = currentWeatherUseCase
        self.forecastUseCase = forecastUseCase
    }
    
    // MARK: - METHODS
    //
    func didTapForecastButton() {
        fetchForecast { [weak self] (lat, lon) in
            guard let self = self else { return }
            let viewModel = ForecastViewModel(latitude: lat, longitude: lon, searchType: .currentLocation(coordinates: "\(lat) \(lon)"))
            self.navigationSubject.onNext(.forecast(viewModel: viewModel))
        }
    }
    
    func didTapCurrentWeatherButton() {
        navigationSubject.onNext(.currentWeather(viewModel: CurrentWeatherViewModel()))
    }
    
    func fetchCurrentWeather() {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        currentWeatherUseCase
            .excute(units: .celsius, fromCache: true)
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

private extension DashboardViewModel {
    func fetchForecast(onSuccess: @escaping ((Double, Double) -> Void)) {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        forecastUseCase
            .excute(units: .celsius, fromCache: true)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.stateRelay.accept(.successful)
                
                switch result {
                case .success(let data):
                    if let lat = data.coordinates?.lat, let lon = data.coordinates?.lon {
                        onSuccess(lat, lon)
                    } else {
                        self.alertItemRelay.accept(.init(message: ErrorType.unexpected.message))
                    }
                    
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
