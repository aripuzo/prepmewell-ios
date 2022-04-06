//
//  StudyTime.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 23/03/2022.
//

import Foundation

class StudyTime: NSObject, Codable {
    var recordNo: Int
    var studyTimeName: String
    
    public override var description: String {
        return studyTimeName
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case studyTimeName = "StudyTimeName"
    }
}
