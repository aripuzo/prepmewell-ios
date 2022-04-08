//
//  TestScheduleWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import Foundation

protocol TestScheduleProtocol {
    func getSchedules(success: @escaping (DataResponse<ScheduleDataResponse>) -> (), failure: @escaping (String) -> ())
    func scheduleTest(data: ScheduleUpdate, success: @escaping (DataResponse<Schedule>) -> (), failure: @escaping (String) -> ())
    func getTestTypes(success: @escaping (ListResponse<TestType>) -> (), failure: @escaping (String) -> ())
    func getMockTests(testTypeFk: Int, mockTypeFK: Int?, pageNo: Int?, success: @escaping (ListResponse<MockTest>) -> (), failure: @escaping (String) -> ())
}

class TestScheduleWorker: TestScheduleProtocol {
    var networkClient: PrepmewellApiClient?

    func scheduleTest(data: ScheduleUpdate, success: @escaping (DataResponse<Schedule>) -> (), failure: @escaping (String) -> ()) {
        print(data.prettyJSON)
        let params = data.paramsFromJSON()
        
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/MockTestSchedule", params: params!) {(feedback: DataResponse<Schedule>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getSchedules(success: @escaping (DataResponse<ScheduleDataResponse>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/MockTestSchedule/ScheduleData", params: [:]) {(feedback: DataResponse<ScheduleDataResponse>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getTestTypes(success: @escaping (ListResponse<TestType>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/TestType/All", params: [:]) {(feedback: ListResponse<TestType>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getMockTests(testTypeFk: Int, mockTypeFK: Int?, pageNo: Int?, success: @escaping (ListResponse<MockTest>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/MockTestV1/All", params: ["TestTypeFk" : testTypeFk]) {(feedback: ListResponse<MockTest>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
