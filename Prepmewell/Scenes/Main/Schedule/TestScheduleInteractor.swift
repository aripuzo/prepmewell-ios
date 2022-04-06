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
    
}
