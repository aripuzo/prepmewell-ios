//
//  Study.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import Foundation

class Study: NSObject, Codable {
    var recordNo: Int
    var studyName: String
    
    init(_ recordNo: Int, studyName: String) {
        self.recordNo = recordNo
        self.studyName = studyName
    }
    
    public override var description: String {
        return studyName
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case studyName = "StudyName"
    }
}
