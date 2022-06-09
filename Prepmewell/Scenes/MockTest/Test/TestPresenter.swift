//
//  WritingTestPresenter.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestPresentationLogic {
    func displayQuestion(questionResponse: QuestionResponse)
    func endTestResponse(response: TestResult)
    func displayError(alert: String)
    func uploadTestResponse(response: UploadTestResponse)
    func updateProgress(progress: Double)
}

class TestPresenter: TestPresentationLogic {
    
    var view: TestDisplayLogic?

    func displayQuestion(questionResponse: QuestionResponse) {
        view?.displayQuestion(questionResponse: questionResponse)
    }
    
    func endTestResponse(response: TestResult) {
        view?.endTestResponse(response: response)
    }
    
    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
    func uploadTestResponse(response: UploadTestResponse) {
        (view as! WritingTestDisplayLogic).uploadTestResponse(response: response)
    }
    
    func updateProgress(progress: Double) {
        (view as! WritingTestDisplayLogic).updateProgress(progress: progress)
    }
    
}
