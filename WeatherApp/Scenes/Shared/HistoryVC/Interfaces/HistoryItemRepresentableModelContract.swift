//
//  HistoryItemRepresentableModelContract.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 08/05/2023.
//

protocol HistoryItemRepresentableModelContract {
    var name: String? { get }
    var type: SearchItem { get }
    var zipcode: String? { get }
    var coordinates: Coord? { get }
}
