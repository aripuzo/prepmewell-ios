//
//  GameResultViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 04/04/2022.
//

import UIKit
import NVActivityIndicatorView

protocol TestResultDisplayLogic {
    func displayTestResult(response: DataResponse<TestResult>)
    func displayError(alert: String)
}

class GameResultViewController: UIViewController, TestResultDisplayLogic, NVActivityIndicatorViewable {
    
    func displayTestResult(response: DataResponse<TestResult>) {
        stopAnimating()
        testResult = response.response
        questions.append(contentsOf: testResult!.mockTestResultDetail!)
        showResult()
    }
    
    private func showResult() {
        timeSpentLabel.text = testResult!.totalTimeSpent2
        bestTimeLabel.text = testResult!.mockTest!.totalTime
        scoreLabel.text = "\(testResult!.achievedBandScore!)"
        targetScoreLabel.text = "\(testResult!.mockTest!.targetScore!)"
        correctAnswerLabel.text = "\(testResult!.correctAnswer!)"
        worldPositionLabel.text = "\(testResult!.achievedBandScore!)th"
        
        questionListTable.reloadData()
    }
    
    func displayError(alert: String) {
        stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var targetScoreLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var worldPositionLabel: UILabel!
    @IBOutlet weak var bestPositionLabel: UILabel!
    @IBOutlet weak var bestPerfomanceLabel: UILabel!
    @IBOutlet weak var questionListTable: UITableView!
    
    var testResult: TestResult?
    var interactor : TestResultBusinessLogic?
    var questions: [MockTestResultDetail] = []
    let size = CGSize(width: 80, height: 80)
    
    func setUpDependencies() {
        let interactor = TestResultInteractor()
        let worker = TestResultWorker()
        let presenter = TestResultPresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.view = self
       
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionListTable.register(UINib(nibName: "GameTestResultCell", bundle: nil),
                           forCellReuseIdentifier: GameTestResultCell.identifier)
        questionListTable.rowHeight = UITableView.automaticDimension
        questionListTable.estimatedRowHeight = 40
        
        questionListTable.delegate = self
        questionListTable.dataSource = self
        questionListTable.backgroundColor = .clear
        
        setUpDependencies()

        if (testResult?.mockTestResultDetail == nil || testResult?.mockTestResultDetail?.isEmpty == true) {
            self.startAnimating(self.size, message: "Getting result...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
            interactor?.getTestResult(testResultFk: testResult!.recordNo)
        }
    }

}

extension GameResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameTestResultCell = self.questionListTable.dequeueReusableCell(withIdentifier: GameTestResultCell.identifier) as! GameTestResultCell
        cell.item = questions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
