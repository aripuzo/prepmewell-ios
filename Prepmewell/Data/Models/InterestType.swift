//
//  InterestType.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 23/03/2022.
//

import Foundation

class InterestType: NSObject, Codable {
    var recordNo: Int
    var interestTypeName: String
    
    public override var description: String {
        return interestTypeName
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case interestTypeName = "InterestTypeName"
    }
}
