//
//  ReadingTestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import UIKit

class ReadingTestViewController: TestViewController {
    
    @IBOutlet weak var questionsTable: UITableView!
    
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

        setUpTestNavigation()
        setUpDependencies()
        interactor?.getQuestions(mockTestFK: mockTest.recordNo)
    }
    
    override func closeInfoDialog() {
        startTest()
    }

    override func startTest() {
        //stopwatch()
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
        
        questionsTable.reloadData()
        print("count: \(questionGroups.count)")
        
        submitButton.isHidden = !isLast
        leftImageView.isHidden = isFirst
        rightImageView.isHidden = isLast
        
        questionGroup.mockTestQuestion.forEach({item in
            if (!answers.keys.contains(item.question.recordNo)) {
                answers[item.question.recordNo] = QuestionAnswer(questionFK: item.question.recordNo, answer: "", wordCount: 0)
            }
        })
    }
}

extension ReadingTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionGroupCell = self.questionsTable.dequeueReusableCell(withIdentifier: QuestionGroupCell.identifier) as! QuestionGroupCell
        cell.questionGroup = self.questionGroups[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
