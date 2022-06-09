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
    func displayInterest(interests: ListResponse<Interest>)
    func logout()
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    func displayUser(user: User?){
        if user != nil {
            Defaults[\.userData] = user
            if user?.firstName == nil && user?.lastName == nil && user?.fullName == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ScreenID.PROFILE_UPDATE) as! ProfileUpdateViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if user?.firstName != nil {
                nameLabel.text = "Hi, \(user!.firstName!) 👋"
            }
            else if user?.lastName != nil {
                nameLabel.text = "Hi, \(user!.lastName!) 👋"
            }
            else {
                nameLabel.text = "Hi, \(user!.fullName!) 👋"
            }
            interactor?.getInterest(studentFk: user!.id)
        } else {
            nameLabel.text = "Hi"
        }
    }

    func displayDashboard(dashboard: Dashboard?) {
        if dashboard != nil {
            perfomance.removeAll()
            
            targetScoreLabel.text = dashboard!.getAverageScoreString()
            averageScoreLabel.text = dashboard!.getAverageAccuracyString()
            totalTestLabel.text = "\(dashboard!.testTaken)"
            averageTimeLabel.text = dashboard?.getAverageTimeString()
            
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
    
    func displayInterest(interests: ListResponse<Interest>){
        completeQuestionaireView.isHidden = !interests.response.isEmpty
    }
    
    func displayError(prompt: String) {
        print(prompt,"<><><><><><><><><><>")
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        performSegue(withIdentifier: "homeToQuestionnaire", sender: nil)
    }
    
    func logout() {
        Defaults.removeAll()
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        UIWindow.key?.rootViewController = controller
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
        
        performanceTable.register(UINib(nibName: "PerformanceCellView", bundle: nil),
                           forCellReuseIdentifier: PerformanceCellView.identifier)
        performanceTable.backgroundColor = .clear
        
        setUpDependencies()
        displayUser(user: Defaults[\.userData])
        displayDashboard(dashboard: nil)
        interactor?.getUser()
        interactor?.getDashboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        //completeQuestionaireView.addGestureRecognizer(tap)
    }
   
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perfomance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PerformanceCellView = self.performanceTable.dequeueReusableCell(withIdentifier: PerformanceCellView.identifier) as! PerformanceCellView
                
        cell.performance = self.perfomance[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 217
    }
}
