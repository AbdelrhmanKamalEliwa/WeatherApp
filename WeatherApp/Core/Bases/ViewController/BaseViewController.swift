//
//  BaseViewController.swift
//
//  Created by Abdelrhman Eliwa.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    deinit {
        print("deinit ", self.self)
    }
}

// MARK: - Navigation
//
extension BaseViewController {
    
    enum NavigationType {
        case push
        case present(fullScreen: Bool)
        case presentWtih(presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle)
    }
    
    func go(to view: UIViewController, navigationType: NavigationType, with animation: Bool = true) {
        switch navigationType {
        case .push:
            guard let nav = self.navigationController else {
                print("Can't find navigation controller")
                return
            }
            nav.pushViewController(view, animated: animation)
            
        case .present(let fullScreen):
            present_helper(presentationStyle: fullScreen ? .fullScreen : .automatic)
            
        case .presentWtih(let presentationStyle, let transitionStyle):
            present_helper(
                presentationStyle: presentationStyle,
                transitionStyle: transitionStyle
            )
        }
        
        func present_helper(
            presentationStyle: UIModalPresentationStyle = .automatic,
            transitionStyle: UIModalTransitionStyle = .coverVertical
        ) {
            let nav = UINavigationController(rootViewController: view)
            nav.modalPresentationStyle = presentationStyle
            nav.modalTransitionStyle = transitionStyle
            present(nav, animated: true)
        }
    }
    
    func goBack(to view: UIViewController? = nil, with animation: Bool = true) {
        guard let nav = self.navigationController else {
            print("Can't find navigation controller")
            return
        }
        
        if let view = view {
            nav.popToViewController(view, animated: true)
        } else {
            nav.popViewController(animated: animation)
        }
    }
    
    func goToRoot() {
        guard let nav = self.navigationController else {
            print("Can't find navigation controller")
            return
        }
        nav.popToRootViewController(animated: true)
    }
}
