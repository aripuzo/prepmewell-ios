//
//  Game.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 30/03/2022.
//

import UIKit

struct Game: Codable {
    let mockTestFK: Int
    let testtypeName: String
    let testName: String
    let description: String?
    let subTitle: String?
    let letterGuide: String?
    
    enum CodingKeys: String, CodingKey {
        case mockTestFK = "MockTestFK"
        case testtypeName = "TesttypeName"
        case testName = "TestName"
        case description = "Description"
        case subTitle = "SubTitle"
        case letterGuide = "LetterGuide"
    }

    func getImage() -> UIImage {
        switch testName {
            case "True or False":
                return #imageLiteral(resourceName: "audio-fill")
            case "Antonyms":
                return #imageLiteral(resourceName: "mic-fill")
            case "Synonyms":
                return #imageLiteral(resourceName: "book-fill")
            case "Complete The Sentences":
                return #imageLiteral(resourceName: "book-fill")
            case "IELTS Tips":
                return #imageLiteral(resourceName: "book-fill")
            default:
                return #imageLiteral(resourceName: "edit-fill")
        }
    }
}
