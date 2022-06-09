//
//  WritingTestInteractor.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestBusinessLogic {
    func getQuestions(mockTestFK: Int)
    func endTest(mockTestFK: Int, answers: [QuestionAnswer])
    func uploadWritingTest(testNumber: Int, testType: String, testName: String, image: Data)
    func uploadSpeakingTest(file: Data, fileName: String)
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
    
    func endTest(mockTestFK: Int, answers: [QuestionAnswer]) {
        worker?.endTest(mockTestFK: mockTestFK, answers: answers, success: { (feedback) in
            if let response = feedback.response {
                self.presenter?.endTestResponse(response: response)
            }
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func uploadWritingTest(testNumber: Int, testType: String, testName: String, image: Data) {
        worker?.uploadWritingTest(testNumber: testNumber, testType: testType, testName: testName, image: image, progress: { (progress) in self.presenter?.updateProgress(progress: progress) }, success: { (feedback) in
            if feedback != nil {
                self.presenter?.uploadTestResponse(response: feedback)
            }
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func uploadSpeakingTest(file: Data, fileName: String) {
        worker?.uploadSpeakingTest(file: file, fileName: fileName, progress: { (progress) in self.presenter?.updateProgress(progress: progress) }, success: { (feedback) in
            if feedback != nil {
                self.presenter?.uploadTestResponse(response: feedback)
            }
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
