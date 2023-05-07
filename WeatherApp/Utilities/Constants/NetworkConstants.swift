//
//  NetworkConstants.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

enum NetworkConstants {
    enum Range {
        static let statusCode = 200...299
    }
    
    static let retries: Int = 3
    static let baseUrl: String = getBaseUrl()
    
    static let timeoutIntervalForRequest: Double = 120
    
    private static func getBaseUrl() -> String {
        let scheme = EnvironmentManager.shared.string(key: .serverScheme)
        let host = EnvironmentManager.shared.string(key: .serverHost)
        
        return "\(scheme)://\(host)"
    }
    
    static func getBaseImageURL(forImageID id: String, andSize size: ImageSize = .regular) -> String {
        switch size {
        case .regular: return getBaseUrl() + "/img/w/\(id)"
        case .large: return getBaseUrl() + "/img/wn/\(id)@4x.png"
        }
    }
    
    enum ImageSize {
        case regular
        case large
    }
}
