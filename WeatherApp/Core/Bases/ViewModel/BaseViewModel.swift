//
//  BaseViewModel.swift
//
//  Created by Abdelrhman Eliwa.
//

import RxSwift
import RxRelay

class BaseViewModel: DisposeObject {
    var stateRelay = BehaviorRelay<ViewModelState<BaseError>>.init(value: .idle)
    var alertItemRelay = BehaviorRelay<AlertItem?>.init(value: nil)
}
