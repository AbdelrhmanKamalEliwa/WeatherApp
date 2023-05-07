//
//  Data+Helpers.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

public extension Data {
    var utfString: String? {
        return String(data: self, encoding: .utf8)
    }
    
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    var json: [String : Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String : Any]
            return json
        } catch {
            print("Can't convert data to json")
            return [:]
        }
    }
}
