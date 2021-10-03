//
//  TestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import UIKit

open class TestViewController: UIViewController {
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
    }
    
    func registerAnswerTextObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didPostQuestionAnswer, object: nil)
    }

}

extension TestViewController: TestDisplayLogic {
    
    func displayQuestion(questionResponse: QuestionResponse) {
        if questionResponse != nil {
            self.questionResponse = questionResponse
            for (index, questionGroup) in self.questionResponse!.question.enumerated() {
                if isNext(questionGroup: questionGroup) {
                    position = index
                    activeQuestionGroup = questionGroup
                    firstPosition = index
                    break
                }
            }
        }
        if let questionResponse = self.questionResponse {
            bindActiveQuestion(questionGroup: activeQuestionGroup!)
            showInstructions(questionResponse: questionResponse)
        }
    }
    
    func endTestResponse(response: TestResultResponse) {
        
    }
    
    func displayError(alert: String) {
        
    }
}
