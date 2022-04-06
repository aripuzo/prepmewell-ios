//
//  GameQuestionGroup.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 30/03/2022.
//

import Foundation

struct GameQuestionGroup: Codable {
    
    let recordNo: Int
    let groupName: String
    let dropDownName: String
    let isNameVisible: Bool
    let isDescriptionVisible: Bool

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case groupName = "GroupName"
        case dropDownName = "DropDownName"
        case isNameVisible = "IsNameVisible"
        case isDescriptionVisible = "IsDescriptionVisible"
    }
}
