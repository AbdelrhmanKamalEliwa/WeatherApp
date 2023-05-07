//
//  DashboardViewModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

typealias DashboardViewModelContract = BaseViewModel & DashboardViewModelOutputsContract & DashboardViewModelInputsContract

protocol DashboardViewModelInputsContract {
    func fetchCurrentWeather()
    func didTapForecastButton()
    func didTapCurrentWeatherButton()
}

protocol DashboardViewModelOutputsContract {
    var weatherSubject: PublishSubject<CurrentWeatherRepresentableModelContract> { get }
    var dataSourceSubject: PublishSubject<[WeatherRepresentableModelContract]> { get }
    var navigationSubject: PublishSubject<DashboardViewModel.Navigation> { get }
}
