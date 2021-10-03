//
//  QuestionCell.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import UIKit
import BEMCheckBox

class QuestionCell: UITableViewCell {
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noView: UIView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var optionCollection: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var dropDownField: UITextField!
    @IBOutlet weak var deleteButton: UIView!
    @IBOutlet weak var recordButton: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var answerFieldStartConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerFieldTopConstraint: NSLayoutConstraint!
    
    var questionOptions: [QuestionOption] = []
    let screenSize: CGRect = UIScreen.main.bounds
    
    var groupbx = BEMCheckBoxGroup()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        optionCollection.register(UINib(nibName: "QuestionOptionCell", bundle: nil),
                                  forCellWithReuseIdentifier: QuestionOptionCell.identifier)
        optionCollection.contentInsetAdjustmentBehavior = .never
        
        optionCollection.delegate = self
        optionCollection.dataSource = self
        
        answerField.delegate = self
    }
    
    var mockTestQuestion: MockTestQuestion?  {
        didSet {
            if let mockTestQuestion = mockTestQuestion {
                answerField.addBottomBorder(height: 1, color: UIColor(named: "Text1") ?? UIColor.black)
                answerField.isHidden = true
                optionCollection.isHidden = true
                dropDownField.isHidden = true
                buttonView.isHidden = true
                if !mockTestQuestion.question.questionOption.isEmpty {
                    bodyLabel.text = mockTestQuestion.question.questionName?.htmlToString
                    optionCollection.isHidden = false
                    groupbx = BEMCheckBoxGroup()
                    questionOptions.removeAll()
                    questionOptions.append(contentsOf: mockTestQuestion.question.questionOption)
                    optionCollection.reloadData()
                    //Todo: connect answer
                }
                if mockTestQuestion.question.questionName?.contains("%NS") == true {
                    let text = mockTestQuestion.question.questionName!
                    let start = text.substring(to: text.index(of: "%NS") ?? 0).htmlToString
                    let end = text.substring(from:
                        (text.lastIndex(of: "NS%") ?? 0) + 3
                    ).htmlToString
                    bodyLabel.text = start + "                                           " + end
                    answerField.isHidden = false
                    
                    var startWidth = start.width(withConstrainedHeight: 10, font: bodyLabel.font)
                    let startHeight = start.height(withConstrainedWidth: startWidth, font: bodyLabel.font)
                    
                    if screenSize.width < (startWidth + 140) {
                        startWidth = screenSize.width - 230
                        answerFieldTopConstraint.constant = startHeight + answerFieldTopConstraint.constant
                    }
                    
                    answerFieldStartConstraint.constant = startWidth
                }
            }
        }
    }
    
    func setAnswer(answer: String?, questionFk: Int) {
        if answer != nil && !answer!.isEmpty {
            noView.backgroundColor = UIColor(named: "Blue blue")
            if !answerField.isHidden {
                answerField.text = answer
            }
            if !questionOptions.isEmpty {
                print("................................................................")
                print("got here \(questionFk)")
                for (index, item) in questionOptions.enumerated() {
                    print(index)
                    let cell = optionCollection.cellForItem(at: IndexPath(index: index)) as! QuestionOptionCell
                    if cell.questionFk == questionFk && answer == item.optionName {
                        cell.checkBoxView.on = true
                    }
                    print(cell.questionFk)
                }
            }
        } else {
            noView.backgroundColor = UIColor(named: "Light blue")
            answerField.text = ""
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension QuestionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questionOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionOptionCell.identifier, for: indexPath as IndexPath) as! QuestionOptionCell
        cell.questionOption = self.questionOptions[indexPath.row]
        cell.questionFk = self.questionOptions[indexPath.row].questionFK
        
        groupbx.addCheckBox(toGroup: cell.checkBoxView)
        
        return cell
    }
}

extension QuestionCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let answer: [Int: String?] = [mockTestQuestion!.questionFk: textField.text]
        NotificationCenter.default.post(
            name: .didPostQuestionAnswer,
            object: self,
            userInfo: ["Answer" : answer])
        setAnswer(answer: textField.text, questionFk: mockTestQuestion!.questionFk)
    }

}
