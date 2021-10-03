//
//  TestListWorker.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import Foundation
import Alamofire

protocol TestListProtocol {
    func getMockTests(testTypeFk: Int, mockTypeFK: Int?, pageNo: Int?, success: @escaping (ListResponse<MockTest>) -> (), failure: @escaping (String) -> ())
    
    func startTest(mockTestFK: Int, writingTypeName: String?, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ())
}

class TestListWorker: TestListProtocol {
    var networkClient: PrepmewellApiClient?

    func getMockTests(testTypeFk: Int, mockTypeFK: Int?, pageNo: Int?, success: @escaping (ListResponse<MockTest>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/MockTestV1/All", params: ["TestTypeFk" : testTypeFk, "MockTypeFK" : mockTypeFK, "PageNo": pageNo]) {(feedback: ListResponse<MockTest>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func startTest(mockTestFK: Int, writingTypeName: String?, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute2(requestType: .post, url: "\(Constants.URL)api/MockTest/StartMockTest?MockTestFK=\(mockTestFK)&WritingTypeName=\(writingTypeName ?? "")", params: [:]) {(feedback: StringResponse) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
