//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

// MARK: - ForecastResponse
struct ForecastResponse: Codable, Equatable {
    let list: [Forecast]?
    let city: City?
}

// MARK: - City
struct City: Codable, Equatable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Forecast
struct Forecast: Codable, Equatable {
    let main: Main?
    let weather: [Weather]?
    let wind: Wind?
    let rain: Rain?
    let dateString: String?

    enum CodingKeys: String, CodingKey {
        case main, weather, wind, rain
        case dateString = "dt_txt"
    }
}
