//
//  CurrentWeatherHistoryViewModel.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

class CurrentWeatherHistoryViewModel: HistoryViewModel {
    private var onSelectItem: ((CurrentWeatherHistoryItem) -> Void)
    
    private var dataSource: [CurrentWeatherHistoryItem] = [] {
        didSet {
            dataSourceSubject.onNext(dataSource)
        }
    }
    
    init(onSelectItem: @escaping ((CurrentWeatherHistoryItem) -> Void)) {
        self.onSelectItem = onSelectItem
        
        super.init()
    }
    
    override func loadHistory() {
        dataSource = cacheManager.currentWeatherHistory
    }
    
    override func didSelectItem(at index: Int) {
        let item = dataSource[index]
        onSelectItem(item)
    }
}
