//
//  Encodable+Helpers.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

extension Encodable {
    var query: String {
        guard let data = try? JSONEncoder().encode(self),
              let json = String(data: data, encoding: .utf8),
              let output = json.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return ""
        }
        
        return output
    }
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var data: Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            fatalError("Couldn't encode Data")
        }
    }
    
    var json: String? {
        return String(data: data, encoding: .utf8)
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
    }
}
