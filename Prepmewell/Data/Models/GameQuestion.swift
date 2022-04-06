//
//  GameQuestion.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 31/03/2022.
//

import Foundation

struct GameQuestion: Codable {
    let question: Question
    let questionGroup: String?
    let recordNo: Int
    let sortOrder: Int
    let questionFk: Int
    let questionGroupFK: Int
    let createdOn: String
    
    enum CodingKeys: String, CodingKey {
        case question = "Question"
        case questionGroup = "QuestionGroup"
        case recordNo = "RecordNo"
        case sortOrder = "SortOrder"
        case questionFk = "QuestionFk"
        case questionGroupFK = "QuestionGroupFK"
        case createdOn = "CreatedOn"
    }
}

//@Parcelize
//data class QuestionType (
//    @SerializedName("RecordNo")
//    val recordNo: Long,
//
//    @SerializedName("QuestionTypeName")
//    val questionTypeName: String,
//
//    @SerializedName("CreatedOn")
//    val createdOn: String,
//
//    @SerializedName("UpdatedOn")
//    val updatedOn: String? = null,
//
//    @SerializedName("IsDeleted")
//    val isDeleted: Boolean
//): Parcelable
