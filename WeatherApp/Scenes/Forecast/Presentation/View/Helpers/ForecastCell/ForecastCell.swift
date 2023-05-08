//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var currentTempValueLabel: UILabel!
    @IBOutlet private weak var minTempValueLabel: UILabel!
    @IBOutlet private weak var maxTempValueLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    static let height: CGFloat = 250
    
    private var dataSource: [WeatherRepresentableModelContract] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCell(cellClass: ForecastWeatherCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        selectionStyle = .none
    }
   
    func configure(using data: ForecastRepresentableModelContract) {
        currentTempValueLabel.text = "\(data.temp) ℃"
        minTempValueLabel.text = "\(data.minTemp) ℃"
        maxTempValueLabel.text = "\(data.maxTemp) ℃"
        dateLabel.text = data.date
        dataSource = data.weathers
    }
}


// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
//
extension ForecastCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: ForecastWeatherCell = collectionView.dequeue(indexPath: indexPath)
        let model = dataSource[indexPath.item]
        cell.configure(using: model)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        ForecastWeatherCell.size
    }
}
