//
//  TestDisplayLogic.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestDisplayLogic {
    func displayQuestion(questionResponse: QuestionResponse)
    func endTestResponse(response: TestResult)
    func displayError(alert: String)
}

protocol WritingTestDisplayLogic: TestDisplayLogic {
    func uploadTestResponse(response: UploadTestResponse)
    func updateProgress(progress: Double)
}
