//
//  APIServiceContract.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation
import RxSwift

protocol APIServiceContract {
    func request<T: Decodable>(
        using request: URLRequest,
        responseType: T.Type,
        decoder: JSONDecoder,
        retry: Int,
        errorResolver: ErrorResolverContract
    ) -> Observable<Result<T, BaseError>>
}

extension APIServiceContract {
    func request<T: Decodable>(
        using request: URLRequest,
        responseType: T.Type = T.self,
        decoder: JSONDecoder = .init(),
        retry: Int = NetworkConstants.retries,
        errorResolver: ErrorResolverContract = ErrorResolver.shared
    ) -> Observable<Result<T, BaseError>> {
        self.request(
            using: request,
            responseType: responseType,
            decoder: decoder,
            retry: retry,
            errorResolver: errorResolver
        )
    }
}
