//
//  UICollectionView+Helpers.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit

extension UICollectionView {
    func registerCell<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        self.register(Cell.loadNib(), forCellWithReuseIdentifier: String(describing: Cell.self))
    }


    func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }

}
