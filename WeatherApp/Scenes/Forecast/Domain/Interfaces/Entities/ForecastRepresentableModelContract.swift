//
//  ForecastRepresentableModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

protocol ForecastRepresentableModelContract {
    var date: String { get }
    var temp: String { get }
    var minTemp: String { get }
    var maxTemp: String { get }
    var weathers: [Weather] { get }
}

extension Forecast: ForecastRepresentableModelContract {
    var date: String {
        dateString ?? "N/A"
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
    
    var weathers: [Weather] {
        self.weather ?? []
    }
}
