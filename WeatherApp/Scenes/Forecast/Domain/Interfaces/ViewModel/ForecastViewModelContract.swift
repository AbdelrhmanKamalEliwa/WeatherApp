//
//  ForecastViewModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift
import RxRelay

typealias ForecastViewModelContract = BaseViewModel & ForecastViewModelInputsContract & ForecastViewModelOutputsContract

protocol ForecastViewModelInputsContract {
    var firstTextFieldRelay: BehaviorRelay<String> { get set }
    var secondTextFieldRelay: BehaviorRelay<String> { get set }
    
    func didLoad()
    func search()
    func didTapSearchFiltersButton()
    func didTapHistoryButton()
}

protocol ForecastViewModelOutputsContract {
    var historySubject: PublishSubject<ForecastHistoryItem> { get }
    var forecastSubject: PublishSubject<ForecastResponseRepresentableModelContract> { get }
    var dataSourceSubject: PublishSubject<[ForecastRepresentableModelContract]> { get }
    var navigationSubject: PublishSubject<ForecastViewModel.Navigation> { get }
    var searchTypeRelay: BehaviorRelay<SearchType?> { get }
}

