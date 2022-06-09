//
//  TestWorker.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

protocol TestWorkerProtocol {
    func getQuestions(mockTestFK: Int, success: @escaping (DataResponse<QuestionResponse>) -> (), failure: @escaping (String) -> ())
    
    func endTest(mockTestFK: Int, answers: [QuestionAnswer], success: @escaping (DataResponse<TestResult>) -> (), failure: @escaping (String) -> ())
    
    func uploadWritingTest(testNumber: Int, testType: String, testName: String, image: Data, progress: @escaping (Double) -> (), success: @escaping (UploadTestResponse) -> (), failure: @escaping (String) -> ())
    
    func uploadSpeakingTest(file: Data, fileName: String, progress: @escaping (Double) -> (), success: @escaping (UploadTestResponse) -> (), failure: @escaping (String) -> ())
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
    
    func endTest(mockTestFK: Int, answers: [QuestionAnswer], success: @escaping (DataResponse<TestResult>) -> (), failure: @escaping (String) -> ()) {
        
        var params: [String] = []
        answers.forEach{ answer in
            params.append(answer.prettyJSON)
        }
        
        networkClient?.execute3(requestType: .post, url: "\(Constants.URL)api/MockTest/EndMockTest?MockTestFK=\(mockTestFK)", json: "\(params)") {(feedback: DataResponse<TestResult>) in
        success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func uploadWritingTest(testNumber: Int, testType: String, testName: String, image: Data, progress: @escaping (Double) -> (), success: @escaping (UploadTestResponse) -> (), failure: @escaping (String) -> ()) {
        networkClient?.upload(file: image, fileName: "image.png", fileType: "image/png", to: "http://54.218.94.151/Apis/WritingUpload.php", params: ["test_number": testNumber, "test_type": testType, "file": testName], progress: progress, success: success, failure: failure)
    }
    
    func uploadSpeakingTest(file: Data, fileName: String, progress: @escaping (Double) -> (), success: @escaping (UploadTestResponse) -> (), failure: @escaping (String) -> ()) {
        networkClient?.upload(file: file, fileName: fileName, fileType: "application/octet-stream", to: "https://indigovisas.com/api/AwsS3/speakingV1", params: [:], progress: progress, success: success, failure: failure)
    }
}
