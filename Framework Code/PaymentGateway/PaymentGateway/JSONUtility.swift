//
//  JSONUtility.swift
//  PaymentGateway
//
//  Created by iOS Dev on 24/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation



// MARK:- Type alias for JSON format
internal typealias JSON = [String: Any]



internal class JSONUtility {
    
    /* Apply sorting on JSON keys, & returns formatted for "Hashing" String */
    class func jsonToString(dictionary: JSON) -> String {
        let sortedDictionary = dictionary.sorted(by: {
            $0.key < $1.key
        })
        
        var string = ""
        for entity in sortedDictionary {
            string.append("\(entity.key)=\(entity.value)&")
        }
        string.removeLast()
        return string
    }
    
    
    /* Returns ***> JSON <*** created from string */
    class func stringToJSON(string: String) -> JSON? {
        if let data = string.data(using: .utf8) {
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = jsonObj as? JSON {
                    return dict
                }
            } catch { }
        }
        return nil
    }
    
    
    /* Returns value as ***> String <*** object */
    class func stringValue(_ value: Any?) -> String? {
        if let object = value as? String { return object }
        return nil
    }
    
    
    /* Returns value as ***> Int <*** value */
    class func intValue(_ value: Any?) -> Int? {
        if let object = value as? Int { return object }
        if let object = Int(JSONUtility.stringValue(value) ?? "") { return object }
        return nil
    }
}
