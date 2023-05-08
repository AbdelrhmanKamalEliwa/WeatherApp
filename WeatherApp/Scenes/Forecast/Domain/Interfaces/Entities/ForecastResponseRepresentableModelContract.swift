//
//  ForecastResponseRepresentableModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import Foundation

protocol ForecastResponseRepresentableModelContract {
    var name: String? { get }
    var coordinates: Coord? { get }
    var forecasts: [ForecastRepresentableModelContract] { get }
}

extension ForecastResponse: ForecastResponseRepresentableModelContract {
    var name: String? {
        self.city?.name
    }
    
    var coordinates: Coord? {
        self.city?.coord
    }
    
    var forecasts: [ForecastRepresentableModelContract] {
        self.list ?? []
    }
}
