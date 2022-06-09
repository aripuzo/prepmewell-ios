//
//  TestResultViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 09/04/2022.
//

import UIKit
import NVActivityIndicatorView
import XLPagerTabStrip

class TestHistoryViewController: ButtonBarPagerTabStripViewController, TestResultDisplayLogic, NVActivityIndicatorViewable {
    
    func displayTestResult(response: DataResponse<TestResult>) {
        stopAnimating()
        testResult = response.response
        questions.append(contentsOf: testResult!.mockTestResultDetail!)
        showResult()
    }
    
    private func showResult() {
        title = "\(testResult!.mockTest!.mockType!.mockTypeName) Test: \(testResult!.mockTest!.testName)"
        timeLabel.text = testResult!.totalTimeSpent2
        bestTimeLabel.text = testResult!.mockTest!.totalTime
        scoreLabel.text = "\(testResult!.achievedBandScore!)"
        targetScoreLabel.text = "\(testResult!.mockTest!.targetScore!)"
        
        skillLevelLabel.text = ""
        descriptionLabel.text = ""
        suggestionsLabel.text = ""
        
        if testResult?.mockTest?.testTypeFk == Constants.TEST_TYPE_WRITING {
            questionListTable.isHidden = true
            currentAnswerLabel.isHidden = true
            
            containerView.isHidden = false
            buttonBarView.isHidden = false
        }
        else {
            questionListTable.isHidden = false
            currentAnswerLabel.isHidden = false
            questionListTable.reloadData()
            
            containerView.isHidden = true
            buttonBarView.isHidden = true
        }
    }
    
    func displayError(alert: String) {
        stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    @IBOutlet weak var targetScoreLabel: UILabel!
    @IBOutlet weak var skillLevelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var suggestionsLabel: UILabel!
    @IBOutlet weak var questionListTable: SelfSizedTableView!
    @IBOutlet weak var currentAnswerLabel: UILabel!
    
    var isReload = false
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
        
        questionListTable.register(UINib(nibName: "TestResultCell", bundle: nil),
                           forCellReuseIdentifier: TestResultCell.identifier)
        questionListTable.rowHeight = UITableView.automaticDimension
        questionListTable.estimatedRowHeight = 88
        
        questionListTable.delegate = self
        questionListTable.dataSource = self
        questionListTable.backgroundColor = .clear
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor(named: "Accent")!
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont(name:"Calibre-Regular", size:16)!
        settings.style.buttonBarItemTitleColor = UIColor(named: "Text2")
        
        setUpDependencies()

        if (testResult?.mockTestResultDetail == nil || testResult?.mockTestResultDetail?.isEmpty == true) {
            self.startAnimating(self.size, message: "Getting result...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
            interactor?.getTestResult(testResultFk: testResult!.recordNo)
        }
        
        registerAnswerExplanationObsever()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.WRITTEN_HISTORY) as! WrittenHistoryViewController
        child_1.testResult = testResult
        
        
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.WRITTEN_HISTORY) as! WrittenHistoryViewController
        child_2.testResult = testResult

        guard isReload else {
            return [child_1, child_2]
        }

        var childViewControllers = [child_1, child_2]

        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childViewControllers.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
    
    func registerAnswerExplanationObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didPostExplainAnswer, object: nil)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        guard let question = (notification.userInfo?["Question"]) as? MockTestResultDetail else {
            return
        }
        let vc = ExplanationModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.question = question
        self.present(vc, animated: false)
    }

}

extension TestHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TestResultCell = self.questionListTable.dequeueReusableCell(withIdentifier: TestResultCell.identifier) as! TestResultCell
        cell.setDetail(item: questions[indexPath.row], testTypeFk: testResult!.mockTest!.testTypeFk)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if testResult!.mockTest!.testTypeFk == Constants.TEST_TYPE_READING {
            let vc = ExplanationModalViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.question = questions[indexPath.row]
            self.present(vc, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
