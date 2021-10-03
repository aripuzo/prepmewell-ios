//
//  WritingTestInteractor.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestBusinessLogic {
    func getQuestions(mockTestFK: Int)
    func endTest(mockTestFK: Int)
}

class TestInteractor: TestBusinessLogic {
    var presenter: TestPresentationLogic?
    var worker: TestWorkerProtocol?

    func getQuestions(mockTestFK: Int) {
        worker?.getQuestions(mockTestFK: mockTestFK, success: { (feedback) in
            if let response = feedback.response {
                self.presenter?.displayQuestion(questionResponse: response)
            }
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func endTest(mockTestFK: Int) {
        worker?.endTest(mockTestFK: mockTestFK, success: { (feedback) in
            if let response = feedback.response {
                self.presenter?.endTestResponse(response: response)
            }
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
