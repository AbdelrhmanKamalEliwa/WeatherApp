//
//  ForecastRepository.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

final class ForecastRepository: DisposeObject, ForecastRepositoryContract {
    
    let service: APIServiceContract
    var cacheManager: CacheManagerContract?
    
    init(
        service: APIServiceContract = APIService.shared,
        cacheManager: CacheManagerContract? = CacheManager.shared
    ) {
        self.service = service
        self.cacheManager = cacheManager
    }
    
    func getForecast<T: Encodable>(
        using requestModel: T,
        forItem searchType: SearchItem,
        fromCache: Bool
    ) -> Observable<Result<ForecastResponse, BaseError>> {
        
        guard fromCache else {
            return getForecastFromRemote(using: requestModel, forItem: searchType)
        }
        
        if let data = cacheManager?.forecastHistory.first {
            return .create { observer in
                observer.onNext(.success(data.data))
                observer.onCompleted()
                return Disposables.create()
            }
        } else {
            return .create { observer in
                observer.onNext(.failure(.init(code: -1, message: "Can not find data in cache, please search for weather and fetch forecast.")))
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}

// MARK: - PRIVATE METHODS
//
private extension ForecastRepository {
    func getForecastFromRemote<T: Encodable>(
        using requestModel: T,
        forItem searchType: SearchItem
    ) -> Observable<Result<ForecastResponse, BaseError>> {

        let request = APIBuilder()
            .setPath(using: .forecast)
            .setMethod(using: .get)
            .setParameters(using: .query(requestModel.dictionary))
            .build()

        let remoteObserver: Observable<Result<ForecastResponse, BaseError>> = service.request(using: request)

        remoteObserver
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if case .success(let response) = result {
                    self.cacheForecast(
                        data: response,
                        requestModel: (requestModel as? GetCurrentWeatherSearchRequestModelContract),
                        searchType: searchType
                    )
                }
            })
            .disposed(by: disposeBag)

        return remoteObserver
    }
    
    func cacheForecast(
        data: ForecastResponse,
        requestModel: GetCurrentWeatherSearchRequestModelContract?,
        searchType: SearchItem
    ) {
        guard
            var cacheManager = cacheManager,
            !cacheManager.forecastHistory.contains(where: { $0.data == data })
        else { return }

        let zipCode = requestModel?.q
        cacheManager.forecastHistory.insert(
            .init(data: data, type: searchType, zipcode: searchType == .zipCode ? zipCode : nil),
            at: 0
        )
    }
}
