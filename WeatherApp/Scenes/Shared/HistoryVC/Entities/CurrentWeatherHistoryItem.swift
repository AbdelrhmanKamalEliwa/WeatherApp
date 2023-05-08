//
//  CurrentWeatherHistoryItem.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

struct CurrentWeatherHistoryItem: Codable {
    let data: GetCurrentWeatherResponse
    let type: SearchItem
    var zipcode: String? = nil
}

extension CurrentWeatherHistoryItem: HistoryItemRepresentableModelContract {
    var name: String? {
        data.name
    }
    
    var coordinates: Coord? {
        data.coord
    }
}
