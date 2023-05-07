//
//  Decodable+Helpers.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation

extension Decodable {
    static func decode(_ json: String?) -> Self? {
        guard let json = json else { return nil }
        let jsonData = Data(json.utf8)
        return Self.decode(jsonData)
    }
    
    static func decode(_ json: Data?) -> Self? {
        guard let json = json else { return nil }
        do {
            return try JSONDecoder().decode(Self.self, from: json)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

