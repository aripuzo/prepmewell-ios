//
//  QuestionCell.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import UIKit
import BEMCheckBox
import RAMAnimatedTabBarController

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
    @IBOutlet weak var recordButtonLabel: UILabel!
    @IBOutlet weak var recordButtonImage: UIImageView!
    
    let playImage = UIImage(named: "play-circle-blue")
    let pauseImage = UIImage(named: "pause-circle-blue")
    let micImage = UIImage(named: "mic")
    
    var questionOptions: [QuestionOption] = []
    let screenSize: CGRect = UIScreen.main.bounds
    
    fileprivate var mockTestQuestion: MockTestQuestion?
    
    var groupbx = BEMCheckBoxGroup()
    
    var recordAction: () -> Void = { }
    var deleteAction: () -> Void = { }
    
    var answer: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        optionCollection.register(UINib(nibName: "QuestionOptionCell", bundle: nil),
                                  forCellWithReuseIdentifier: QuestionOptionCell.identifier)
        optionCollection.contentInsetAdjustmentBehavior = .never
        
        optionCollection.delegate = self
        optionCollection.dataSource = self
        optionCollection.backgroundColor = .clear
        
        answerField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.recordClicked))
        recordButton.addGestureRecognizer(tap)
        recordButton.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.deleteClicked))
        deleteButton.addGestureRecognizer(tap2)
        deleteButton.isUserInteractionEnabled = true
    }
    
    func setQuestion(mockTestQuestion: MockTestQuestion?)  {
        self.mockTestQuestion = mockTestQuestion
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
                groupbx.mustHaveSelection = true
                questionOptions.removeAll()
                questionOptions.append(contentsOf: mockTestQuestion.question.questionOption)
                optionCollection.reloadData()
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
            } else {
                bodyLabel.text = mockTestQuestion.question.questionName?.htmlToString
            }
        }
    }
    
    func setAnswer(answer: String?, questionFk: Int, testType: Int, isPlaying: Bool = false) {
        self.answer = answer
        if answer != nil && !answer!.isEmpty {
            noView.backgroundColor = UIColor(named: "Blue blue")
            if !answerField.isHidden {
                answerField.text = answer
            }
            if testType == Constants.TEST_TYPE_SPEAKING {
                buttonView.isHidden = false
                deleteButton.isHidden = false
                if isPlaying {
                    recordButtonImage.image = pauseImage
                } else {
                    recordButtonImage.image = playImage
                }
                recordButtonLabel.text = "YOUR ANSWER"
                recordButtonLabel.textColor = UIColor(named: "Accent")
            }
            else {
                if !questionOptions.isEmpty {
                    optionCollection.reloadData()
                }
            }
        } else {
            noView.backgroundColor = UIColor(named: "Light blue")
            answerField.text = ""
            if testType == Constants.TEST_TYPE_SPEAKING {
                buttonView.isHidden = false
                deleteButton.isHidden = true
                recordButtonLabel.text = "RECORD ANSWER"
                recordButtonLabel.textColor = UIColor(named: "Cool red")
                recordButtonImage.image = micImage
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @objc func recordClicked(sender: UIButton!) {
        recordAction()
    }
    
    @objc func deleteClicked(sender: UIButton!) {
        deleteAction()
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
        cell.setAnswer(answer: answer)
        
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
        setAnswer(answer: textField.text, questionFk: mockTestQuestion!.questionFk, testType: Constants.TEST_TYPE_LISTENING)
    }

}
