//
//  AsyncImageView.swift
//  PlayWithWeatherAPI
//
//  Created by Abdelrhman Eliwa.
//

import UIKit
import SDWebImage

@IBDesignable
class AsyncImageView: UIImageView {
    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        sd_imageIndicator = SDWebImageActivityIndicator.large
    }
    
    func setImage(using url: String?) {
        sd_setImage(with: URL(string: url.value), completed: nil)
    }
    
    func setImage(using id: String) {
        let url = NetworkConstants.getBaseImageURL(forImageID: id)
        sd_setImage(with: URL(string: url), completed: nil)
    }
}
