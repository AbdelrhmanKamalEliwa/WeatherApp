//
//  GetCurrentWeatherRequestModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

protocol GetCurrentWeatherRequestModelContract: Encodable {
    var lat: Double { get }
    var lon: Double { get }
    var units: WeatherUnits { get }
}
