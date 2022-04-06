//
//  GamePlayViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 31/03/2022.
//

import UIKit
import NVActivityIndicatorView

protocol GamePlayDisplayLogic {
    func displayNextQuestion(response: DataResponse<GameQuestion>)
    func displayAnswerQuestion(response: ListResponse<GameAnswer>)
    func endGameResponse(response: StringResponse)
    func displayError(alert: String)
}

class GamePlayViewController: UIViewController, GamePlayDisplayLogic, NVActivityIndicatorViewable {
    
    func displayNextQuestion(response: DataResponse<GameQuestion>) {
        stopAnimating()
        self.updateCount(count: self.questionCount + 1)
        if !startedGame {
            startedGame = !startedGame
            startTimer()
        }
        self.displayCurrentQuestion(currentQuestion: response.response!)
    }
    
    func displayAnswerQuestion(response: ListResponse<GameAnswer>) {
        stopAnimating()
        currentAnswer = response.response[0]
        buttonView.isHidden = currentAnswer == nil
        if currentAnswer?.isCorrect == true {
            self.updateScore(score: self.score + 5)
        } else {
            self.updateScore(score: self.score - 5)
        }
        questionListTable.reloadData()
    }
    
    func endGameResponse(response: StringResponse) {
        stopAnimating()
        self.navigationController?.popViewController(animated: true)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.GAME_RESULT) as! GameResultViewController
        vc.testResult = self.gameTestResult!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func displayError(alert: String) {
        stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var questionTimeLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var questionNameLabel: UILabel!
    @IBOutlet weak var questionListTable: UITableView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    var myAnswer: String?
    var gameTestResult: TestResult?
    var gameQuestionGroup: GameQuestionGroup?
    var startedGame = false
    var timer: Timer!
    var questionTimer: Timer!
    var endDate: Date?
    var totalTime: Double = 10
    var startTime: Date!
    
    var currentQuestion: GameQuestion?
    var currentAnswer: GameAnswer?
    var questionCount: Int = 0
    var score: Int = 0
    var interactor : GamePlayBusinessLogic?
    var questions: [QuestionOption] = []
    private let sectionInsets = UIEdgeInsets(
      top: 15.0,
      left: 15.0,
      bottom: 15.0,
      right: 15.0)
    let size = CGSize(width: 80, height: 80)
    
    func setUpDependencies() {
        let interactor = GamePlayInteractor()
        let worker = GamePlayWorker()
        let presenter = GamePlayPresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.view = self
       
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        questionListTable.register(UINib(nibName: "GameAnswerCell", bundle: nil),
                           forCellReuseIdentifier: GameAnswerCell.identifier)
        questionListTable.rowHeight = UITableView.automaticDimension
        questionListTable.estimatedRowHeight = 50
        
        questionListTable.delegate = self
        questionListTable.dataSource = self
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "back-icon") , style: .plain, target: self, action: #selector(backAction(sender:)))
        customBackButton.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = customBackButton
        
        setUpDependencies()
        
        getNextQuestion()
    }
    
    @objc func backAction(sender: UIBarButtonItem) {
        let vc = InstructionsModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.heading = "Are you sure?"
        vc.body = "You are just few seconds away from finishing the game. Do you still want to leave?"
        vc.buttonText = "EXIT GAME"
        vc.buttonAction = {
            self.endGame()
        }
        self.present(vc, animated: false)
    }
    
    private func displayCurrentQuestion(currentQuestion: GameQuestion) {
        currentAnswer = nil
        self.currentQuestion = currentQuestion
        explanationLabel.text = self.currentQuestion!.question.explanation
        questionNameLabel.text = self.currentQuestion!.question.questionName
        buttonView.isHidden = currentAnswer == nil
        
        questions.removeAll()
        questions.append(contentsOf: self.currentQuestion!.question.questionOption)
        questionListTable.reloadData()
        self.startQuestionTimer()
    }
    
    private func endGame(){
        interactor?.endGame(gameResultFK: gameTestResult!.recordNo)
    }
    
    private func updateScore(score: Int) {
        self.score = score
        scoreLabel.text = "Score: \(self.score)"
    }
    
    private func updateCount(count: Int) {
        self.questionCount = count
        countLabel.text = self.questionCount > 0 ? "Count: \(self.questionCount)" : "Complete the note below"
    }
    
    func startQuestionTimer() {
        if self.questionTimer != nil {
            self.questionTimer.invalidate()
        }
        self.questionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateQuestionTime), userInfo: nil, repeats: true)
         //NSRunLoop.currentRunLoop().addTimer(self.questionTimer, forMode: NSRunLoopCommonModes)
        startTime = Date() // new instance variable that you would need to add.
    }

    @objc func updateQuestionTime() {
        let elapsedTime = Date().timeIntervalSince(startTime)
        let currTime = totalTime - elapsedTime
        //total time is an instance variable that is the total amount of time in seconds that you want
        questionTimeLabel.text = "00:\(String(format: "%02d", currTime))"
        if currTime < 0 {
            questionTimer.invalidate()
            //do other stuff that you need to do when time runs out.
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateStartTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateStartTime() {
        let userCalendar = Calendar.current
        // Set Current Date
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        let currentDate = userCalendar.date(from: components)!
        if endDate == nil {
            endDate = currentDate.addingTimeInterval(300)
        }
            
        // Change the seconds to days, hours, minutes and seconds
        let timeLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: endDate!)
            
        // Display Countdown
        title = String(format: "%02d:%02d", timeLeft.minute!, timeLeft.second!)
            
        // Show diffrent text when the event has passed
        endEvent(currentdate: currentDate, eventdate: endDate!)
    }
        
    func endEvent(currentdate: Date, eventdate: Date) {
        if currentdate >= eventdate {
            self.endGame()
            timer.invalidate()
        }
    }
    
    func getNextQuestion() {
        interactor?.nextQuestion(gameResultFK: gameTestResult!.recordNo, questionGroupFK: gameQuestionGroup!.recordNo)
        self.startAnimating(self.size, message: "Getting next question...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
    }
    
    @IBAction func didPressNextBtn() {
        getNextQuestion()
    }
    
    @IBAction func didPressInfoBtn() {
        let vc = InstructionsModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.heading = "Instructions"
        vc.body = "You have just 10 seconds to answer each question. Choose the word that best defines the provided word. The faster you answer each question, the higher your score."
        vc.buttonText = "START GAME"
        vc.buttonAction = {}
        self.present(vc, animated: false)
    }

}

extension GamePlayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameAnswerCell = self.questionListTable.dequeueReusableCell(withIdentifier: GameAnswerCell.identifier) as! GameAnswerCell
        cell.setQuestionItem(item: questions[indexPath.row], myAnswer: myAnswer, currentAnswer: currentAnswer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = questions[indexPath.row]
        if currentAnswer == nil {
            myAnswer = item.optionName
            interactor?.answerQuestion(gameResultFK: gameTestResult!.recordNo, gameQuestionFK: self.currentQuestion!.recordNo, answer: myAnswer!)
            self.startAnimating(self.size, message: "Getting next question...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
            self.questionListTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
