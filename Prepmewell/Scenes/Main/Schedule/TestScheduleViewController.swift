//
//  TestScheduleViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import UIKit

protocol TestScheduleDisplayLogic {
    func displaySchedules(schedules: DataResponse<ScheduleDataResponse>)
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
        
        filteredList = scheduleList.filter { $0.getScheduleTime()!.isSameDay(selectedDate!) }
        
        scheduleListTable.reloadData()
        scheduleCollection.reloadData()
    }
    
    func displayError(alert: String) {
        
    }
    
    @IBOutlet weak var scheduleCollection: UICollectionView!
    @IBOutlet weak var scheduleListTable: UITableView!
    @IBOutlet weak var fab: UIView!
    
    private var scheduleList: [Schedule] = []
    private var filteredList: [Schedule] = []
    var interactor : TestScheduleBusinessLogic?
    var dates: [Date] = []
    var selectedDate: Date?
    
    func setUpDependencies() {
        let interactor = TestScheduleInteractor()
        let worker = TestScheduleWorker()
        let presenter = TestSchedulePresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.view = self
       
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scheduleListTable.register(UINib(nibName: "ScheduleCell", bundle: nil),
                           forCellReuseIdentifier: ScheduleCell.identifier)
        scheduleListTable.estimatedRowHeight = 112
        
        scheduleListTable.delegate = self
        scheduleListTable.dataSource = self
        scheduleListTable.backgroundColor = .clear
        
        scheduleCollection.delegate = self
        scheduleCollection.dataSource = self
        scheduleCollection.isSkeletonable = true
        scheduleCollection.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        fab.addGestureRecognizer(tap)
        
        setUpDependencies()
        
        interactor?.getSchedules()
        
        initDate()
    }
    
    private func initDate() {
        let startDate = Date()
        let endDate = startDate.adding(months: 2)
        
        dates = Date.dates(from: startDate, to: endDate)
        
        selectedDate = dates[0]
        
        scheduleCollection.reloadData()
    }
    
    @objc func didTapButton(){
        performSegue(withIdentifier: "schedulesToNew", sender: nil)
    }
    
    func showInstructions(schedule: Schedule) {
        let vc = ScheduleModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.subtitle = schedule.getStartTime()
        vc.heading = "\(schedule.testTypeName!) Test: \(schedule.mockTestName!)"
        switch schedule.status {
            case 1:
                vc.body = "You have taken this test, what do you want to do?"
                vc.buttonText = "TAKE TEST AGAIN"
                vc.buttonText2 = "VIEW PERFROMANCE"
                break;
            case 2:
                vc.body = "You missed this test, what do you want to do?"
                vc.buttonText = "START TEST NOW"
                vc.buttonText2 = "EDIT SCHEDULE"
                vc.buttonAction2 = {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.NEW_SCHEDULE) as! NewScheduleViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.schedule = schedule
                }
                break;
            default:
                vc.body = "This test is due in 2 hours, what do you want to do?"
                vc.buttonText = "START TEST NOW"
                vc.buttonText2 = "EDIT SCHEDULE"
                vc.buttonAction2 = {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.NEW_SCHEDULE) as! NewScheduleViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.schedule = schedule
                }
        }
        vc.buttonAction = {
            
        }
        
        self.present(vc, animated: false)
    }

}

extension TestScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleCell = self.scheduleListTable.dequeueReusableCell(withIdentifier: ScheduleCell.identifier) as! ScheduleCell
        cell.item = filteredList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showInstructions(schedule: filteredList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
}

extension TestScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCalenderView", for: indexPath as IndexPath) as! ScheduleCalenderView
        
        let currDate = dates[indexPath.row]
        cell.setDate(date: currDate, isSelected: selectedDate == currDate, schedules: scheduleList.filter { $0.getScheduleTime()!.isSameDay(currDate) })
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates[indexPath.row]
        filteredList = scheduleList.filter { $0.getScheduleTime()!.isSameDay(selectedDate!) }
        scheduleCollection.reloadData()
        scheduleListTable.reloadData()
    }
}
