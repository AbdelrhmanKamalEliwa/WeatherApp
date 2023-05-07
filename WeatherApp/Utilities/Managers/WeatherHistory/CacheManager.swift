//
//  CacheManager.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    
    private init() { }
}

// MARK: - CacheManagerContract
//
extension CacheManager: CacheManagerContract {
    var userDefaults: UserDefaultsManagerContract {
        UserDefaultsManager.shared
    }
}
