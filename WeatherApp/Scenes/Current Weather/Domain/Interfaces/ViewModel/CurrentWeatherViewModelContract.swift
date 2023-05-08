//
//  CurrentWeatherViewModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift
import RxRelay

typealias CurrentWeatherViewModelContract = BaseViewModel & CurrentWeatherViewModelOutputsContract & CurrentWeatherViewModelInputsContract

protocol CurrentWeatherViewModelInputsContract {
    var firstTextFieldRelay: BehaviorRelay<String> { get set }
    var secondTextFieldRelay: BehaviorRelay<String> { get set }
    
    func didLoad()
    func didTapForecastButton()
    func search()
    func didTapSearchFiltersButton()
    func didTapTempTypeButton()
    func didTapHistoryButton()
}

protocol CurrentWeatherViewModelOutputsContract {
    var historySubject: PublishSubject<CurrentWeatherHistoryItem> { get }
    var weatherSubject: PublishSubject<CurrentWeatherRepresentableModelContract> { get }
    var dataSourceSubject: PublishSubject<[WeatherRepresentableModelContract]> { get }
    var navigationSubject: PublishSubject<CurrentWeatherViewModel.Navigation> { get }
    var searchTypeRelay: BehaviorRelay<SearchType?> { get }
    var tempTypeRelay: BehaviorRelay<WeatherUnits> { get }
}
