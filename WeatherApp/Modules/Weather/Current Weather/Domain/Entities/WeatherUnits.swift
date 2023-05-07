//
//  WeatherUnits.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

enum WeatherUnits: String, Encodable {
    case celsius = "metric"
    case fahrenheit = "imperial"
    
    var unitString: String {
        switch self {
        case .celsius:
            return "℃"
        case .fahrenheit:
            return "℉"
        }
    }
}
