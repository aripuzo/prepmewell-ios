//
//  Dashboard.swift
//  Prepmewell
//
//  Created by ari on 8/17/21.
//

import UIKit

struct Dashboard: Codable {
    let testTaken: Int
    let averageScore, averageAccuracy: Double
    let averageTime: String
    let listening, reading, writing, speaking: [Performance]

    enum CodingKeys: String, CodingKey {
        case testTaken = "TestTaken"
        case averageScore = "AverageScore"
        case averageAccuracy = "AverageAccuracy"
        case averageTime = "AverageTime"
        case listening
        case reading = "Reading"
        case writing = "Writing"
        case speaking = "Speaking"
    }
    
    func getAverageTimeString()-> String {
        if averageTime.isEmpty || !averageTime.contains(".") {
            return averageTime
        }
        return averageTime.substring(to: averageTime.index(of: ".")!)
    }
    
    func getAverageScoreString()-> String {
        return String(format: "%.1f", averageScore)
    }

    func getAverageAccuracyString()-> String {
        return String(format: "%.2f", averageAccuracy)
    }
}

// MARK: - Performance
struct Performance: Codable {
    let testTypeName: String
    let totalTestTaken, totalQuestion, correctQuestion, incorrectQuestion: Int
    let unanswerQuestion: Int
    let averageAccuracy: Double
    let averageTime, startTime: String
    let averageBandScore: Double
    let ta, cc, lr, gra: Int
    let lastachievedbandscore: Int

    enum CodingKeys: String, CodingKey {
        case testTypeName = "TestTypeName"
        case totalTestTaken = "TotalTestTaken"
        case totalQuestion = "TotalQuestion"
        case correctQuestion = "CorrectQuestion"
        case incorrectQuestion = "IncorrectQuestion"
        case unanswerQuestion = "UnanswerQuestion"
        case averageAccuracy = "AverageAccuracy"
        case averageTime = "AverageTime"
        case startTime = "StartTime"
        case averageBandScore = "AverageBandScore"
        case ta = "TA"
        case cc = "CC"
        case lr = "LR"
        case gra = "GRA"
        case lastachievedbandscore = "Lastachievedbandscore"
    }
    
    func getIcon()-> UIImage {
        switch testTypeName {
            case "Listening":
                return #imageLiteral(resourceName: "audio-fill")
            case "Speaking":
                return #imageLiteral(resourceName: "mic-fill")
            case "Reading":
                return #imageLiteral(resourceName: "book-fill")
            default:
                return #imageLiteral(resourceName: "edit-fill")
        }
    }
}

struct DashboardResponse: Codable {
    let dashboard: Dashboard
    
    enum CodingKeys: String, CodingKey {
        case dashboard = "DashBoard"
    }
}
