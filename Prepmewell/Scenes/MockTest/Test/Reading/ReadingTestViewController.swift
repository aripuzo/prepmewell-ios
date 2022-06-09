//
//  ReadingTestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import UIKit
import NVActivityIndicatorView

class ReadingTestViewController: TestViewController {
    
    override func didEndTest(response: TestResult) {
        stopAnimating()
        self.navigationController?.popViewController(animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ScreenID.TEST_HISTORY) as! TestHistoryViewController
        vc.testResult = response
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var questionsTable: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func isNext(questionGroup: QuestionGroup)-> Bool {
        return questionGroup.mockTestQuestion.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsTable.register(UINib(nibName: "QuestionGroupCell", bundle: nil),
                           forCellReuseIdentifier: QuestionGroupCell.identifier)
        questionsTable.rowHeight = UITableView.automaticDimension
        questionsTable.estimatedRowHeight = 600
        
        questionsTable.delegate = self
        questionsTable.dataSource = self
        questionsTable.backgroundColor = .clear

        timeLabel.text = "00:00 \\ 00:00"
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "back-icon") , style: .plain, target: self, action: #selector(backAction(sender:)))
        customBackButton.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = customBackButton

        setUpTestNavigation()
        setUpDependencies()
        registerAnswerTextObsever()
        startAnimating(size, message: "Loading questions...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        interactor?.getQuestions(mockTestFK: mockTest.recordNo)
    }
    
    override func closeInfoDialog() {
        startTest()
    }

    override func startTest() {
        stopwatch()
    }
    
    override func bindActiveQuestion(questionGroup: QuestionGroup) {
        questionGroups.removeAll()
        questionGroups.append(contentsOf: questionGroup.subGroup)
        titleLabel1.text = questionGroup.groupName
        titleLabel2.text = questionGroup.groupName
        var body: String = questionGroup.questionDescription ?? ""
        let myNewLineStr = "\n"
        body = body.replacingOccurrences(of: "\\n", with: myNewLineStr)
        bodyLabel.text = body
        
        submitButton.isHidden = !isLast
        leftImageView.isHidden = isFirst
        rightImageView.isHidden = isLast
        
        questionGroups.forEach({item in
            item.mockTestQuestion.forEach({item in
                if (!answers.keys.contains(item.question.recordNo)) {
                    answers[item.question.recordNo] = QuestionAnswer(questionFK: item.question.recordNo, answer: "", wordCount: 0)
                }
            })
        })
        print("answers")
        print(answers.count)
        questionsTable.reloadData()
        
    }
    
    override func submitTest() {
        let arrayOfValues = Array(answers.values.map{ $0 })
        startAnimating(size, message: "Submitting test...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        interactor?.endTest(mockTestFK: mockTest!.recordNo, answers: arrayOfValues)
    }
}

extension ReadingTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionGroupCell = self.questionsTable.dequeueReusableCell(withIdentifier: QuestionGroupCell.identifier) as! QuestionGroupCell
        cell.questionGroup = self.questionGroups[indexPath.row]
        cell.answers = answers
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
