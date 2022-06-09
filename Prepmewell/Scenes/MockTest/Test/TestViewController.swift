//
//  TestViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 10/02/2022.
//

import UIKit
import NVActivityIndicatorView

open class TestViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    var mockTest: MockTest!
    var questionResponse: QuestionResponse? = nil
    var activeQuestionGroup: QuestionGroup? = nil
    var firstPosition = 0
    var position = 0
    var isFirst = true
    var isLast = false
    var questionTimer: Timer!
    var startTime: Date!
    var totalTime: TimeInterval = 10 * 60 * 1000
    var isDone = false
    let size = CGSize(width: 80, height: 80)
    
    var interactor : TestBusinessLogic?
    
    var answers: [Int: QuestionAnswer] = [:]
    var questionGroups: [QuestionGroup] = []
    
    func isNext(questionGroup: QuestionGroup) -> Bool {
        return false
    }
    
    func bindActiveQuestion(questionGroup: QuestionGroup) {}
    
    func closeInfoDialog() {}
    
    func startTest() {}

    func submitTest() {}
    
    func endTest() {
        let alert = UIAlertController(title: "Submit Test", message: "Are you sure you are satisfied with you answers and ready to submit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {_ in
            self.submitTest()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setUpDependencies() {
        let interactor = TestInteractor()
        let worker = TestWorker()
        let presenter = TestPresenter()
        let networkClient = PrepmewellApiClient()

        interactor.worker = worker
        interactor.presenter = presenter

        worker.networkClient = networkClient

        presenter.view = self

        self.interactor = interactor
    }
    
    func setUpTestNavigation() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(TestViewController.didPressNextBtn))
        rightImageView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(TestViewController.didPressPreviousBtn))
        leftImageView.addGestureRecognizer(tap2)
    }

    func increasePosition() {
        for i in (position + 1)...questionResponse!.question.count {
            let questionGroup = questionResponse!.question[i]
            if (isNext(questionGroup: questionGroup)) {
                position = i
                activeQuestionGroup = questionGroup
                isFirst = false
                break
            }
        }
        if questionResponse!.question.count < (position + 1) {
            let list = questionResponse!.question[(position + 1)...questionResponse!.question.count]
            let next = list.first(where: { isNext(questionGroup: $0) })
            if (position + 1) >= questionResponse!.question.count || next == nil {
                isLast = true
            }
        } else {
            isLast = true
        }
    }

    func decreasePosition() {
        position = position - 1
        for i in (firstPosition...position).reversed() {
            let questionGroup = questionResponse!.question[i]
            if (isNext(questionGroup: questionGroup)) {
                position = i
                activeQuestionGroup = questionGroup
                isLast = false
                break
            }
        }
        if position == firstPosition {
            isFirst = true
        }
    }
    
    func showInstructions(questionResponse: QuestionResponse) {
        let vc = InstructionsModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.heading = "\(questionResponse.testType.getName()) Instructions: \(questionResponse.testName)"
        vc.body = questionResponse.responseDescription.htmlToString
        vc.buttonText = "CONTINUE"
        vc.buttonAction = {
            if !self.isDone {
                self.closeInfoDialog()
                self.isDone = true
            }
        }
        vc.closeAction = {
            if !self.isDone {
                self.closeInfoDialog()
                self.isDone = true
            }
        }
        self.present(vc, animated: false)
    }
    
    @objc func didPressNextBtn() {
        increasePosition()
        bindActiveQuestion(questionGroup: activeQuestionGroup!)
    }
    
    @objc func didPressPreviousBtn() {
        decreasePosition()
        bindActiveQuestion(questionGroup: activeQuestionGroup!)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        let ar = notification.userInfo?["Answer"] as? [Int: String]
        if ar != nil && !ar!.isEmpty {
            ar!.forEach { print("\($0): \($1)") }
            for (key, value) in ar! {
                if answers.keys.contains(key) {
                    answers[key]!.answer = value
                }
            }
        }
    }
    
    @IBAction func submitButtonPressed() {
        endTest()
    }
    
    func registerAnswerTextObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didPostQuestionAnswer, object: nil)
    }
    
    func stopwatch() {
        if self.questionTimer != nil {
            self.questionTimer.invalidate()
        }
        self.questionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateQuestionTime), userInfo: nil, repeats: true)
        RunLoop.current.add(self.questionTimer, forMode: RunLoop.Mode.common)
        startTime = Date() // new instance variable that you would need to add.
    }

    @objc func updateQuestionTime() {
        let elapsedTime = Date().timeIntervalSince(startTime)
        //let currTime = totalTime - elapsedTime
        DispatchQueue.main.async {
            self.title = elapsedTime.stringFromTimeInterval()
        }
//        if currTime < 0 {
//            questionTimer.invalidate()
//        }
    }
    
    func didEndTest(response: TestResult) {}
    
    @objc func backAction(sender: UIBarButtonItem) {
        let vc = InstructionsModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.heading = "End test?"
        vc.body = "Are you sure fo exit without submitting test result?"
        vc.buttonText = "End"
        vc.buttonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        self.present(vc, animated: false)
    }

}

extension TestViewController: TestDisplayLogic {
    func endTestResponse(response: TestResult) {
        didEndTest(response: response)
    }
    
    func displayQuestion(questionResponse: QuestionResponse) {
        stopAnimating()
        self.questionResponse = questionResponse
        for (index, questionGroup) in self.questionResponse!.question.enumerated() {
            if isNext(questionGroup: questionGroup) {
                position = index
                activeQuestionGroup = questionGroup
                firstPosition = index
                break
            }
        }
        if let questionResponse = self.questionResponse {
            bindActiveQuestion(questionGroup: activeQuestionGroup!)
            showInstructions(questionResponse: questionResponse)
        } else {
            handleErrorMessage(message: "Error loading this test")
        }
    }
    
    func displayError(alert: String) {
        stopAnimating()
        handleErrorMessage(message: alert)
    }
}
