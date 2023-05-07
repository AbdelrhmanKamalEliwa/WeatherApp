//
//  GetCurrentWeatherSearchRequestModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

protocol GetCurrentWeatherSearchRequestModelContract: Encodable {
    var q: String { get }
    var units: WeatherUnits { get }
}
