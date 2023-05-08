//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift
import RxRelay

final class ForecastViewModel: ForecastViewModelContract {
    // MARK: - ENUMS
    //
    enum Navigation {
        case history(viewModel: ForecastHistoryViewModel)
    }
    
    // MARK: - PROPERTIES
    //
    var firstTextFieldRelay: BehaviorRelay<String> = .init(value: "")
    var secondTextFieldRelay: BehaviorRelay<String> = .init(value: "")
    
    private let getForecastUseCase: GetForecastUseCaseContract
    private let latitude: Double
    private let longitude: Double
    private let searchType: SearchType
    private(set) var historySubject: PublishSubject<ForecastHistoryItem> = .init()
    private(set) var navigationSubject: PublishSubject<Navigation> = .init()
    private(set) var forecastSubject: PublishSubject<ForecastResponseRepresentableModelContract> = .init()
    private(set) var dataSourceSubject: PublishSubject<[ForecastRepresentableModelContract]> = .init()
    private(set) var searchTypeRelay: BehaviorRelay<SearchType?> = .init(value: nil)
    
    private var forecastDataSource: [ForecastRepresentableModelContract] = [] {
        didSet {
            dataSourceSubject.onNext(forecastDataSource)
        }
    }
    
    // MARK: - LIFECYCLE
    //
    init(
        latitude: Double,
        longitude: Double,
        searchType: SearchType,
        getForecastUseCase: GetForecastUseCaseContract = GetForecastUseCase()
    ) {
        self.getForecastUseCase = getForecastUseCase
        self.latitude = latitude
        self.longitude = longitude
        self.searchType = searchType
    }
    
    // MARK: - METHODS
    //
    func didLoad() {
        searchTypeRelay.accept(searchType)
        getForecastByCoordinates(latitude: latitude, longitude: longitude)
    }
    
    func didTapHistoryButton() {
        let viewModel = ForecastHistoryViewModel(onSelectItem: { [weak self] item in
            guard let self = self else { return }
            
            self.historySubject.onNext(item)
        })
        navigationSubject.onNext(.history(viewModel: viewModel))
    }
    
    func search() {
        guard let searchType = searchTypeRelay.value else { return }
        
        switch searchType {
        case .cityName:
            getForecastByCityName()
            
        case .zipcode:
            getForecastByZipcode()
            
        case .coordinates:
            getForecastByCoordinates()
            
        case .currentLocation:
            getForecastByCurrentLocation()
        }
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
                        self.getForecastByCurrentLocation()
                    }),
                    .init(title: "Cancel", style: .cancel, action: nil)
                ]
            )
        )
    }
}

// MARK: - PRIVARE METHODS
//
private extension ForecastViewModel {
    func getForecastByCoordinates() {
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
        
        getForecastByCoordinates(latitude: lat, longitude: long)
    }
    
    func getForecastByZipcode() {
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
        
        getForecastByInfo(cityName: firstTextFieldRelay.value)
    }
    
    func getForecastByCityName() {
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
        
        getForecastByInfo(cityName: firstTextFieldRelay.value)
    }
    
    func getForecastByCurrentLocation() {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        getForecastUseCase
            .excute(units: .celsius)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.stateRelay.accept(.successful)
                
                switch result {
                case .success(let data):
                    self.forecastSubject.onNext(data)
                    self.forecastDataSource = data.list ?? []
                    
                    if let lat = data.coordinates?.lat, let lon = data.coordinates?.lon {
                        self.searchTypeRelay.accept(.currentLocation(coordinates: "\(lat) \(lon)"))
                    } else {
                        self.searchTypeRelay.accept(.currentLocation(coordinates: ""))
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
    
    func getForecastByCoordinates(latitude: Double, longitude: Double) {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        getForecastUseCase
            .excute(
                latitude: latitude,
                longitude: longitude,
                units: .celsius,
                isCurrentLocation: !(searchTypeRelay.value == .coordinates)
            )
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.stateRelay.accept(.successful)
                
                switch result {
                case .success(let data):
                    self.forecastSubject.onNext(data)
                    self.forecastDataSource = data.list ?? []
                    
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
    
    
    func getForecastByInfo(cityName: String? = nil, zipcode: String? = nil) {
        guard stateRelay.value != .loading else { return }
        stateRelay.accept(.loading)
        
        getForecastUseCase
            .excute(
                cityName: cityName,
                zipCode: zipcode,
                units: .celsius
            )
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.stateRelay.accept(.successful)
                
                switch result {
                case .success(let data):
                    self.forecastSubject.onNext(data)
                    self.forecastDataSource = data.list ?? []
                    
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
