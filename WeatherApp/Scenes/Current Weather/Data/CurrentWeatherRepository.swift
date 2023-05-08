//
//  CurrentWeatherRepository.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

final class CurrentWeatherRepository: DisposeObject, CurrentWeatherRepositoryContract {
    
    let service: APIServiceContract
    var cacheManager: CacheManagerContract?
    
    init(
        service: APIServiceContract = APIService.shared,
        cacheManager: CacheManagerContract? = CacheManager.shared
    ) {
        self.service = service
        self.cacheManager = cacheManager
    }
    
    func getCurrentWeather<T: Encodable>(
        using requestModel: T,
        forItem searchType: SearchItem,
        fromCache: Bool
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>> {
        
        guard fromCache else {
            return getCurrentWeatherFromRemote(using: requestModel, forItem: searchType)
        }
        
        if let data = cacheManager?.currentWeatherHistory.first {
            return .create { observer in
                observer.onNext(.success(data.data))
                observer.onCompleted()
                return Disposables.create()
            }
        } else {
           return getCurrentWeatherFromRemote(using: requestModel, forItem: searchType)
        }
    }
}

// MARK: - PRIVATE METHODS
//
private extension CurrentWeatherRepository {
    func getCurrentWeatherFromRemote<T: Encodable>(
        using requestModel: T,
        forItem searchType: SearchItem
    ) -> Observable<Result<GetCurrentWeatherResponse, BaseError>> {
        
        
        let request = APIBuilder()
            .setPath(using: .currentWeather)
            .setMethod(using: .get)
            .setParameters(using: .query(requestModel.dictionary))
            .build()
        
        let remoteObserver: Observable<Result<GetCurrentWeatherResponse, BaseError>> = service.request(using: request)
        
        remoteObserver
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if case .success(let response) = result {
                    self.cacheCurrentWeather(
                        data: response,
                        requestModel: (requestModel as? GetCurrentWeatherSearchRequestModelContract),
                        searchType: searchType
                    )
                }
            })
            .disposed(by: disposeBag)
        
        return remoteObserver
    }
    
    func cacheCurrentWeather(
        data: GetCurrentWeatherResponse,
        requestModel: GetCurrentWeatherSearchRequestModelContract?,
        searchType: SearchItem
    ) {
        guard
            var cacheManager = cacheManager,
            !cacheManager.currentWeatherHistory.contains(where: { $0.data == data })
        else { return }
        
        let zipCode = requestModel?.q
        cacheManager.currentWeatherHistory.insert(
            .init(data: data, type: searchType, zipcode: searchType == .zipCode ? zipCode : nil),
            at: 0
        )
    }
}
