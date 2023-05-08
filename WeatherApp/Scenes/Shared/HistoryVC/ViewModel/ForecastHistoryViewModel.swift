//
//  ForecastHistoryViewModel.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 08/05/2023.
//

class ForecastHistoryViewModel: HistoryViewModel {
    private var onSelectItem: ((ForecastHistoryItem) -> Void)
    
    private var dataSource: [ForecastHistoryItem] = [] {
        didSet {
            dataSourceSubject.onNext(dataSource)
        }
    }
    
    init(onSelectItem: @escaping ((ForecastHistoryItem) -> Void)) {
        self.onSelectItem = onSelectItem
        
        super.init()
    }
    
    override func loadHistory() {
        dataSource = cacheManager.forecastHistory
    }
    
    override func didSelectItem(at index: Int) {
        let item = dataSource[index]
        onSelectItem(item)
    }
}
