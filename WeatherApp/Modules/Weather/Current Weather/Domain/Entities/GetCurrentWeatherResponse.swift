//
//  GetCurrentWeatherResponse.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

// MARK: - GetCurrentWeatherResponse
struct GetCurrentWeatherResponse: Codable, Equatable {
    let coord: Coord
    let weather: [Weather]?
    let main: Main?
    let wind: Wind?
    let rain: Rain?
    let name: String?
}

// MARK: - Coord
struct Coord: Codable, Equatable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable, Equatable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct Rain: Codable, Equatable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
struct Weather: Codable, Equatable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind: Codable, Equatable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
