//
//  APIService.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation
import RxSwift
import RxCocoa

final class APIService: NSObject, APIServiceContract {
    static let shared = APIService()
    
    private override init() { }
    
    func request<T: Decodable>(
        using request: URLRequest,
        responseType: T.Type = T.self,
        decoder: JSONDecoder = .init(),
        retry: Int = NetworkConstants.retries,
        errorResolver: ErrorResolverContract
    ) -> Observable<Result<T, BaseError>> {
        return Observable.create { observer in
            
            func handleError(using error: Error) -> BaseError {
                switch error {
                case URLError.networkConnectionLost,
                    URLError.notConnectedToInternet:
                    return errorResolver.getError(for: .connection)
                    
                case is URLError:
                    return errorResolver.getError(for: .unwrappedHttpServer)
                    
                case is DecodingError:
                    return errorResolver.getError(for: .mapping)
                    
                default:
                    return errorResolver.getError(with: error)
                }
            }
            
            return URLSession
                .shared
                .rx
                .response(request: request)
                .debug(request.url?.absoluteString)
                .subscribe(
                    onNext: { response in
                        print(response.data.json ?? "")
                        
                        let statusCode: Int = response.response.statusCode
                        
                        guard NetworkConstants.Range.statusCode.contains(statusCode) else {
                            observer.onNext(.failure(errorResolver.getError(for: .unexpected)))
                            observer.onCompleted()
                            return
                        }
                        
                        guard let decoded = try? decoder.decode(responseType, from: response.data) else {
                            observer.onNext(.failure(errorResolver.getError(for: .mapping)))
                            observer.onCompleted()
                            return
                        }
                        
                        return observer.onNext(.success(decoded))
                    },
                    onError: { error in
                        observer.onNext(.failure(handleError(using: error)))
                        observer.onCompleted()
                    }
                )
        }
    }
}
