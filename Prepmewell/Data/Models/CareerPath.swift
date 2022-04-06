//
//  CareerPath.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 23/03/2022.
//

import Foundation

class CareerPath: NSObject, Codable {
    var recordNo: Int
    var careerPathName: String
    
    public override var description: String {
        return careerPathName
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case careerPathName = "CareerPathName"
    }
}
