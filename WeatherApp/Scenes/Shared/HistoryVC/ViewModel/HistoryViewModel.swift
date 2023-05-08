//
//  HistoryViewModel.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 08/05/2023.
//

import RxSwift
import RxRelay

class HistoryViewModel: BaseViewModel {
    private(set) var dataSourceSubject: PublishSubject<[HistoryItemRepresentableModelContract]> = .init()
    
    let cacheManager: CacheManagerContract
    
    init(
        cacheManager: CacheManagerContract = CacheManager.shared
    ) {
        self.cacheManager = cacheManager
        
        super.init()
    }
    
    func loadHistory() {
        print("loadHistory(): Override me")
    }
    
    func didSelectItem(at index: Int) {
        print("didSelectItem(at index: Int): Override me")
    }
}
