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
        case forecast(viewModel: BaseViewModel)
        case currentWeather(viewModel: CurrentWeatherViewModelContract)
    }
    
    // MARK: - PROPERTIES
    //
    private let currentWeatherUseCase: GetCurrentWeatherUseCaseContract
    
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
    init(currentWeatherUseCase: GetCurrentWeatherUseCaseContract = GetCurrentWeatherUseCase()) {
        self.currentWeatherUseCase = currentWeatherUseCase
    }
    
    // MARK: - METHODS
    //
    func didTapForecastButton() {
        navigationSubject.onNext(.forecast(viewModel: BaseViewModel()))
    }
    
    func didTapCurrentWeatherButton() {
        navigationSubject.onNext(.currentWeather(viewModel: CurrentWeatherViewModel()))
    }
    
    func fetchCurrentWeather() {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        currentWeatherUseCase
            .excute(units: .celsius)
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
