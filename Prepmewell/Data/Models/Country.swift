//
//  Country.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

class Country: NSObject, Codable {
    var recordNo, countryCode: Int
    var countryName, createdOn: String
    
    public override var description: String {
        return countryName
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case countryName = "CountryName"
        case countryCode = "CountryCode"
        case createdOn = "CreatedOn"
    }
}
