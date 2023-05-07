//
//  AlertDisplayer.swift
//
//  Created by Abdelrhman Eliwa.
//

import UIKit
import RxSwift
import RxCocoa

protocol AlertDisplayerProtocol {
    func showAlert(with alertItem: AlertItem?)
}

extension AlertDisplayerProtocol where Self: BaseViewController {
    func bindAlert(to alertItem: BehaviorRelay<AlertItem?>) {
        alertItem.subscribe { [weak self] alertItem in
            guard let self = self else { return }
            guard let alertItem = alertItem.element else { return }
            self.showAlert(with: alertItem)
        }.disposed(by: disposeBag)
    }
    
    func showAlert(with alertItem: AlertItem?) {
        guard let alertItem = alertItem else { return }
        
        let alert = UIAlertController(
            title: alertItem.title,
            message: alertItem.message,
            preferredStyle: alertItem.style
        )
        
        for action in alertItem.actions {
            alert.addAction(action.toUIAlertAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
