//
//  TestScheduleInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import Foundation

protocol TestScheduleBusinessLogic {
    func getSchedules()
    func scheduleTest(data: ScheduleUpdate)
    func getMockTests(testTypeFk: Int, mockTypeFK: Int?, pageNo: Int?)
    func getTestTypes()
}

class TestScheduleInteractor: TestScheduleBusinessLogic {
    var presenter: TestSchedulePresentationLogic?
    var worker: TestScheduleProtocol?

    func getSchedules() {
        worker?.getSchedules(success: { (feedback) in
            self.presenter?.displaySchedules(schedules: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func scheduleTest(data: ScheduleUpdate) {
        worker?.scheduleTest(data: data, success: { (feedback) in
            self.presenter?.displayScheduleTestResponse(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getMockTests(testTypeFk: Int, mockTypeFK: Int? = nil, pageNo: Int? = nil) {
        worker?.getMockTests(testTypeFk: testTypeFk, mockTypeFK: mockTypeFK, pageNo: pageNo, success: { (feedback) in
            self.presenter?.displayMockTests(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getTestTypes() {
        worker?.getTestTypes(success: { (feedback) in
            self.presenter?.displayTestTypes(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
