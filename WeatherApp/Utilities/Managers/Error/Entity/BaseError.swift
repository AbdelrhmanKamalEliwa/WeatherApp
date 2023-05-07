//
//  BaseError.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

struct BaseError: Error {
    let code: Int
    let message: String
}

extension BaseError: Equatable { }
