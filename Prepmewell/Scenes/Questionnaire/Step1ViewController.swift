//
//  Step1ViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import UIKit

class Step1ViewController: UIViewController {
    
    @IBOutlet weak var optionsTable: UITableView!
    
    var options = ["To study abroad", "To work abroad", "To relocate abroad", "Others"]
    var interactor : QuestionnaireBusinessLogic!
    var interestUpdate: InterestUpdate!

    func setUpDependencies() {
        let interactor = QuestionnaireInteractor()
        let worker = QuestionnaireWorker()
        let presenter = QuestionnairePresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        self.interactor = interactor
        
        self.interestUpdate = InterestUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDependencies()
        
        optionsTable.delegate = self
        optionsTable.dataSource = self

        optionsTable.register(QuestionnaireCellView.self, forCellReuseIdentifier: QuestionnaireCellView.identifier)
        
        optionsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myViewController = segue.destination as? Step2aViewController {
            myViewController.interactor = self.interactor as? QuestionnaireInteractor
            myViewController.interestUpdate = self.interestUpdate
        }
        else if let myViewController = segue.destination as? Step2cViewController {
            myViewController.interactor = self.interactor as? QuestionnaireInteractor
            myViewController.interestUpdate = self.interestUpdate
        }
        else if let myViewController = segue.destination as? Step2bViewController {
            myViewController.interactor = self.interactor as? QuestionnaireInteractor
            myViewController.interestUpdate = self.interestUpdate
        }
    }

}

extension Step1ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionnaireCellView = self.optionsTable.dequeueReusableCell(withIdentifier: QuestionnaireCellView.identifier) as! QuestionnaireCellView
                
        cell.text = self.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var destination = ""
        switch indexPath.row {
        case 1:
            destination = "step1ToStep2b"
            break
        case 2:
            destination = "step1ToStep2c"
            break
        default:
            destination = "step1ToStep2a"
        }
        performSegue(withIdentifier: destination, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
