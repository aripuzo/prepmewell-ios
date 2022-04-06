//
//  DegreeQualification.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 23/03/2022.
//

import Foundation

class DegreeQualification: NSObject, Codable {
    var recordNo: Int
    var degreeQualificationName: String
    
    public override var description: String {
        return degreeQualificationName
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case degreeQualificationName = "DegreeQualificationName"
    }
}
