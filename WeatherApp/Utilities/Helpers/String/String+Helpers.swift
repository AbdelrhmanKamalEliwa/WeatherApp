//
//  String+Helpers.swift
//
//  Created by Abdelrhman Eliwa.
//

import UIKit

// MARK: - Variables
extension String {
    
    var isValidCityName: Bool {
        let nameRegex = "^[a-zA-Z\\s-]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
   
    var isValidZipCode: Bool {
        let zipCodeRegex = "^\\d{5}(?:[-\\s]\\d{4})?$"
        let zipCodePredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        return zipCodePredicate.evaluate(with: self)
    }
    
    var localized: String {
        NSLocalizedString(
            self,
            value: self,
            comment: ""
        )
    }
    
    var optional: String? {
        return self.isEmpty ? nil : self
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    var toDouble: Double? {
        return Double(self)
    }
    
    static var empty: String {
        return ""
    }
    
    static var space: String {
        return " "
    }
    
    /// Boolean to identify whether String has content or not
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    /// String with first lettet capitalized
    var capitalize: String {
        return self.prefix(1).capitalized + dropFirst()
    }
    
    var first: String? {
        guard self.isNotEmpty else { return nil }
        return String(self[startIndex])
    }
    
    /// Variable that returns generated HTML from String.
    /// - Returns: Returns generated HTML from String.
    var html: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else { return nil }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var decodedJson: [String: Any]? {
        if let dataFromBase64String = Data(base64Encoded: self) {
            do {
                return try JSONSerialization.jsonObject(with: dataFromBase64String, options: []) as? [String: Any]
            } catch {
                return nil
            }
        }
        return nil
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

// MARK: - Functions
extension String {
    func localizedFormat(using arguments: [CVarArg]) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    /// Method to replace string's sequence with Strings
    /// - Returns: String after replacing sequence
    func replace(_ sequence: String = "##", with: Any) -> String {
        return self.replacingOccurrences(of: sequence, with: "\(with)")
    }
    
    /// Method to decode any string to a generic decodable object
    /// - Parameter decodable: Type of decodable object
    /// - Returns: Converted String to Decodable object
    func decode<D: Decodable>(to decodable: D.Type) -> D? {
        guard let data = self.removingPercentEncoding?.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(D.self, from: data) else {
                  return nil
              }
        
        return decoded
    }
    
    func masked(_ length: Int = 3, reversed: Bool = false) -> String {
        let mask = String(repeating: "*", count: Swift.max(0, count - length))
        return reversed ? mask + suffix(length) : prefix(length) + mask
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", with: "")
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = self
    }
    
    func getStringIndex(index: Int) -> String.Index {
        return String.Index(utf16Offset: index, in: self)
    }
}
