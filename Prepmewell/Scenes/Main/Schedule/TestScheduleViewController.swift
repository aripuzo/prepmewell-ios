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
    //var scheduleList: [Date: Schedule] = [:]
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
        
        scheduleCollection.delegate = self
        scheduleCollection.dataSource = self
        scheduleCollection.isSkeletonable = true
        
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
