//
//  TestDisplayLogic.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestDisplayLogic {
    func displayQuestion(questionResponse: QuestionResponse)
    func endTestResponse(response: TestResultResponse)
    func displayError(alert: String)
}
