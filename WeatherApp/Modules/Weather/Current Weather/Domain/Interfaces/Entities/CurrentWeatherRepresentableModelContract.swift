//
//  CurrentWeatherRepresentableModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

protocol CurrentWeatherRepresentableModelContract {
    var name: String? { get }
    var weathers: [Weather]? { get }
    var temp: String { get }
    var minTemp: String { get }
    var maxTemp: String { get }
}

protocol WeatherRepresentableModelContract {
    var main: String? { get }
    var description: String? { get }
    var icon: String? { get }
}

extension GetCurrentWeatherResponse: CurrentWeatherRepresentableModelContract {
    var weathers: [Weather]? {
        self.weather
    }
    
    var temp: String {
        if let temp = self.main?.temp {
            return "\(Int(temp.rounded()))"
        }
        return "N/A"
    }
    
    var minTemp: String {
        if let temp = self.main?.tempMin {
            return "\(Int(temp.rounded()))"
        }
        return "N/A"
    }
    
    var maxTemp: String {
        if let temp = self.main?.tempMax {
            return "\(Int(temp.rounded()))"
        }
        return "N/A"
    }
}

extension Weather: WeatherRepresentableModelContract { }
