//
//  DisposeObject.swift
//
//  Created by Abdelrhman Eliwa.
//

import RxSwift

class DisposeObject {
    var deinitCalled: (() -> Void)?
    var disposeBag: DisposeBag
    
    init() {
        self.disposeBag = DisposeBag()
    }
    
    deinit {
        deinitCalled?()
    }
}
