//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet private weak var weatherIconImageView: AsyncImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    static let height: CGFloat = 60
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(using configuration: WeatherRepresentableModelContract) {
        if let id = configuration.icon {
            weatherIconImageView.setImage(using: id)
        } else {
            weatherIconImageView.isHidden = true
        }
        
        titleLabel.text = configuration.main ?? ""
        subtitleLabel.text = configuration.description ?? ""
    }
}
