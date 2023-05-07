//
//  CurrentWeatherRepository.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import RxSwift

extension WeatherRepository: CurrentWeatherRepositoryContract {
    func getCurrentWeather<T: Encodable>(
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
    
    private func cacheCurrentWeather(
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
