//
//  UIScrollView+Helpers.swift
//
//  Created by Abdelrhman Eliwa.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    /**
     Shows if the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom of the UIScrollView.
     - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
     */
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = base.frame.height -
            base.contentInset.top -
            base.contentInset.bottom
            
            let yAxisContent = contentOffset.y + base.contentInset.top
            
            let threshold = max(offset, base.contentSize.height - visibleHeight)
            
            return yAxisContent >= threshold
        }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
}
