//
//  WritingTestPresenter.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestPresentationLogic {
    func displayQuestion(questionResponse: QuestionResponse)
    func endTestResponse(response: TestResultResponse)
    func displayError(alert: String)
}

class TestPresenter: TestPresentationLogic {
    var view: TestDisplayLogic?

    func displayQuestion(questionResponse: QuestionResponse) {
        view?.displayQuestion(questionResponse: questionResponse)
    }
    
    func endTestResponse(response: TestResultResponse) {
        view?.endTestResponse(response: response)
    }
    
    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
}
