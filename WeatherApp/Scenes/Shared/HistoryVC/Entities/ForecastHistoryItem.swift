//
//  ForecastHistoryItem.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

struct ForecastHistoryItem: Codable {
    let data: ForecastResponse
    let type: SearchItem
    var zipcode: String? = nil
}

extension ForecastHistoryItem: HistoryItemRepresentableModelContract {
    var name: String? {
        data.name
    }
    
    var coordinates: Coord? {
        data.city?.coord
    }
}
