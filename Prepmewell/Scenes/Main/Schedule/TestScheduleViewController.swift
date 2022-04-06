//
//  TestScheduleViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import UIKit

protocol TestScheduleDisplayLogic {
    func displaySchedules(schedules: DataResponse<ScheduleDataResponse>)
    func displayScheduleTestResponse(response: DataResponse<Schedule>)
    func displayError(alert: String)
}

class TestScheduleViewController: UIViewController, TestScheduleDisplayLogic {
    
    func displaySchedules(schedules: DataResponse<ScheduleDataResponse>) {
        scheduleList.removeAll()
        if schedules.response != nil {
            scheduleList.append(contentsOf: schedules.response!.missed)
            scheduleList.append(contentsOf: schedules.response!.taken)
            scheduleList.append(contentsOf: schedules.response!.pending)
        }
    }
    
    func displayScheduleTestResponse(response: DataResponse<Schedule>) {
        
    }
    
    func displayError(alert: String) {
        
    }
    
    private var scheduleList: [Schedule] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension TestScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameAnswerCell = self.questionListTable.dequeueReusableCell(withIdentifier: GameAnswerCell.identifier) as! GameAnswerCell
        cell.setQuestionItem(item: scheduleList[indexPath.row], myAnswer: myAnswer, currentAnswer: currentAnswer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
}
