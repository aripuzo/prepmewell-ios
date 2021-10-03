//
//  TestWorker.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestWorkerProtocol {
    func getQuestions(mockTestFK: Int, success: @escaping (DataResponse<QuestionResponse>) -> (), failure: @escaping (String) -> ())
    
    func endTest(mockTestFK: Int, success: @escaping (DataResponse<TestResultResponse>) -> (), failure: @escaping (String) -> ())
}

class TestWorker: TestWorkerProtocol {
    var networkClient: PrepmewellApiClient?

    func getQuestions(mockTestFK: Int, success: @escaping (DataResponse<QuestionResponse>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/MockTest/\(mockTestFK)", params: [:]) {(feedback: DataResponse<QuestionResponse>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func endTest(mockTestFK: Int, success: @escaping (DataResponse<TestResultResponse>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/MockTest/EndMockTest", params: ["MockTestFK": mockTestFK]) {(feedback: DataResponse<TestResultResponse>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
