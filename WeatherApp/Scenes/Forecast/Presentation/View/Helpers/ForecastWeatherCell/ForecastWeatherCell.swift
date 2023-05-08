//
//  ForecastWeatherCell.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit

class ForecastWeatherCell: UICollectionViewCell {

    @IBOutlet private weak var weatherIconImageView: AsyncImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    static let size: CGSize = .init(width: 60, height: 50)
    
    func configure(using configuration: WeatherRepresentableModelContract) {
        if let id = configuration.icon {
            weatherIconImageView.setImage(using: id)
        } else {
            weatherIconImageView.isHidden = true
        }
        
        titleLabel.text = configuration.main ?? ""
    }
}
