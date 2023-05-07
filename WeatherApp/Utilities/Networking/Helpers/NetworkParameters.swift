//
//  APIServiceContract.swift
//
//  Created by Abdelrhman Eliwa.
//
import Foundation

/// Enumeration that represents type of Network Parameters
typealias Parameters = [String: Any]

enum RequestParams {
    case body(_: Parameters)
    case query(_: Parameters)
}
