

import Foundation

// MARK: - Contract
//
protocol UserDefaultsManagerContract {
    var userDefaults: UserDefaults { get }
    
    func set(value: Any, for key: UserDefaultsKeys)
    func getValue(for key: UserDefaultsKeys) -> Any?
    func remove(for key: UserDefaultsKeys)
}

// MARK: - Default Implementation
//
extension UserDefaultsManagerContract {
    var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    func set(value: Any, for key: UserDefaultsKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func getValue(for key: UserDefaultsKeys) -> Any? {
        return userDefaults.value(forKey: key.rawValue)
    }
    
    func remove(for key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}

// MARK: - Singleton
//
class UserDefaultsManager: UserDefaultsManagerContract {
    static let shared = UserDefaultsManager()
}
