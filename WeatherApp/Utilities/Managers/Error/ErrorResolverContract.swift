//
//  ErrorResolverContract.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

protocol ErrorResolverContract {
    func getError(for type: ErrorType) -> BaseError
    func getError(with error: Error) -> BaseError
}

extension ErrorResolverContract {
    func getError(for type: ErrorType) -> BaseError {
        return .init(
            code: type.code,
            message: type.message
        )
    }
    
    func getError(with error: Error) -> BaseError {
        return .init(
            code: -1,
            message: error.localizedDescription
        )
    }
}
