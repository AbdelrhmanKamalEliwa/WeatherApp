//
//  SearchItem.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

enum SearchItem: Codable {
    case cityName
    case zipCode
    case coordinates
    case currentLocation
}
