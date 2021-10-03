//
//  WritingTestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import UIKit

class WritingTestViewController: TestViewController {

    @IBOutlet weak var taskNotes: UITextView!
    @IBOutlet weak var uploadContainer: UIView!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    
    
    @IBAction func uploadButtonPressed() {
    }
    
    var writingTypeName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        taskNotes.layer.borderWidth = 1
        taskNotes.layer.borderColor = borderColor.cgColor
        taskNotes.layer.cornerRadius = 4.0
        taskNotes.textContainerInset = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        
        switch writingTypeName {
        case Constants.WRITING_TYPE_UPLOAD:
            taskNotes.isHidden = true
            typeLabel.text = "Upload Script"
        default:
            uploadContainer.isHidden = true
            typeLabel.text = "Type your essays here"
        }
        
        submitButton.isHidden = true
        
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
        titleLabel1.text = questionGroup.groupName
        titleLabel2.text = questionGroup.groupName
        var body: String = questionGroup.questionDescription ?? ""
        let myNewLineStr = "\n"
        body = body.replacingOccurrences(of: "\\n", with: myNewLineStr)
        bodyLabel.text = body
        
        submitButton.isHidden = !isLast
        leftImageView.isHidden = isFirst
        rightImageView.isHidden = isLast
        
        questionGroup.mockTestQuestion.forEach({item in
            if (!answers.keys.contains(item.question.recordNo)) {
                answers[item.question.recordNo] = QuestionAnswer(questionFK: item.question.recordNo, answer: "", wordCount: 0)
            }
        })
    }
    
    override func isNext(questionGroup: QuestionGroup)-> Bool {
        return !questionGroup.mockTestQuestion.isEmpty
    }

}
