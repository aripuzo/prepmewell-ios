//
//  HomeViewController.swift
//  Prepmewell
//
//  Created by ari on 8/13/21.
//

import UIKit
import SwiftyUserDefaults

protocol HomeDisplayLogic {
    func displayUser(user: User?)
    func displayDashboard(dashboard: Dashboard?)
    func displayError(prompt: String)
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    func displayUser(user: User?){
        if user != nil {
            if user?.firstName == nil && user?.lastName == nil {
                //gotoActivity(UpdateProfileActivity::class)
                //requireActivity().finish()
            }
            nameLabel.text = "Hi, \(user!.firstName) 👋"
        } else {
            nameLabel.text = "Hi"
        }
    }

    func displayDashboard(dashboard: Dashboard?) {
        if dashboard != nil {
            perfomance.removeAll()
            
            targetScoreLabel.text = "\(dashboard!.averageScore)"
            averageScoreLabel.text = String(format: "%.2f", dashboard!.averageAccuracy)
            totalTestLabel.text = "\(dashboard!.testTaken)"
            averageTimeLabel.text = "\(dashboard!.averageTime)"
            
            perfomance.append(contentsOf: dashboard!.writing)
            perfomance.append(contentsOf: dashboard!.speaking)
            perfomance.append(contentsOf: dashboard!.reading)
            perfomance.append(contentsOf: dashboard!.listening)
            
            performanceTable.reloadData()
        } else {
            targetScoreLabel.text = "0"
            averageScoreLabel.text = "0"
            totalTestLabel.text = "0"
            averageTimeLabel.text = "0"
        }
    }
    
    func displayError(prompt: String) {
        print(prompt,"<><><><><><><><><><>")
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var targetScoreLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var totalTestLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var completeQuestionaireView: UIView!
    @IBOutlet weak var performanceTable: UITableView!
    
    var interactor : HomeBusinessLogic?
    let cellReuseIdentifier = "performanceCell"
    var perfomance: [Performance] = []
    
    func setUpDependencies() {
        let interactor = HomeInteractor()
        let worker = HomeWorker()
        let presenter = HomePresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.homeView = self
       
        self.interactor = interactor
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performanceTable.delegate = self
        performanceTable.dataSource = self
        
        setUpDependencies()
        displayUser(user: Defaults[\.userData])
        displayDashboard(dashboard: nil)
        interactor?.getUser()
        interactor?.getDashboard()
    }
   
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perfomance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PerformanceCellView = self.performanceTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PerformanceCellView
                
        cell.performance = self.perfomance[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 217
    }
}
