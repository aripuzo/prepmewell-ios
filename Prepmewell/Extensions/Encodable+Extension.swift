//
//  Encodable+Extension.swift
//  Prepmewell
//
//  Created by ari on 8/16/21.
//

import Foundation

extension Encodable {
    var prettyJSON: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self),
            let output = String(data: data, encoding: .utf8)
            else { return "Error converting \(self) to JSON string" }
        return output
    }
    
    func paramsFromJSON() -> [String : AnyObject]?
    {
        let json = prettyJSON
        let objectData: Data = (json.data(using: String.Encoding.utf8))!
        var jsonDict: [ String : AnyObject]!
        do {
            jsonDict = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers) as? [ String : AnyObject]
            return jsonDict
        } catch {
            print("JSON serialization failed:  \(error)")
            return nil
        }
    }
}
