//
//  RelocateLocation.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 23/03/2022.
//

import Foundation

class RelocateLocation: NSObject, Codable {
    var recordNo: Int
    var relocateLocationName: String
    
    public override var description: String {
        return relocateLocationName
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case relocateLocationName = "RelocateLocationName"
    }
}
