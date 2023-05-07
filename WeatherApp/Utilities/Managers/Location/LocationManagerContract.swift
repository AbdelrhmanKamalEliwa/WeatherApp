//
//  LocationManagerContract.swift
//
//  Created by Abdelrhman Eliwa.
//

protocol LocationManagerContract {
    func getCurrentLocation() -> Result<LocationCoordinate, BaseError>
    func requestAuthorization() -> Result<Void, BaseError>
}
