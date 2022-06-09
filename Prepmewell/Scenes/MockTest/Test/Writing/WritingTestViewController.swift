//
//  WritingTestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import UIKit
import NVActivityIndicatorView

class WritingTestViewController: TestViewController, WritingTestDisplayLogic {
    
    func uploadTestResponse(response: UploadTestResponse) {
        stopAnimating()
        answers[currentKey] = QuestionAnswer(questionFK: currentKey, answer: response.name)
        if (currentPos == images.count) {
            currentKey = 0
            let arrayOfValues = Array(answers.values.map{ $0 })
            interactor?.endTest(mockTestFK: mockTest!.recordNo, answers: arrayOfValues)
        } else {
            uploadFile()
        }
    }
    
    func updateProgress(progress: Double) {
        
    }
    
    override func didEndTest(response: TestResult) {
        stopAnimating()
        self.navigationController?.popViewController(animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ScreenID.TEST_END) as! TestEndViewController
        vc.testResult = response
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBOutlet weak var taskNotes: UITextView!
    @IBOutlet weak var uploadContainer: UIView!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var cloudImage: UIImageView!
    
    var images: [Int: UIImage] = [:]
    var currentPos = 0
    var currentKey = 0
    
    @IBAction func uploadButtonPressed() {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { [self] (image) in
            print("got here")
            images[activeQuestionGroup!.mockTestQuestion[0].question.recordNo] = image
            fileImage.image = image
            
            captionLabel.isHidden = true
            cloudImage.isHidden = true
            fileImage.isHidden = false
        }
    }
    
    override func submitTest() {
        if writingTypeName == Constants.WRITING_TYPE_WRITE {
            answers.enumerated().forEach { (index, value) in
                var ans = value.value
                ans.wordCount = ans.answer?.count
                answers.updateValue(ans, forKey: value.key)
            }
            let arrayOfValues = Array(answers.values.map{ $0 })
            startAnimating(size, message: "Submitting test...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
            interactor?.endTest(mockTestFK: mockTest!.recordNo, answers: arrayOfValues)
        } else {
            uploadFile()
        }
    }
    
    func uploadFile() {
        let sortedOne = images.sorted { (first, second) -> Bool in
            return first.key > second.key
        }
        
        if !sortedOne.isEmpty {
            currentKey = Array(answers)[currentPos].key
            currentPos += 1
            sortedOne.enumerated().forEach { (index, value) in
                if value.key == currentKey {
                    let testType = "Task\(mockTest!.testTypeFk)"
                    let testNumber = value.key
                    let fileRequest = "\(mockTest!.testName)\(index)"
                    let data = value.value.jpegData(compressionQuality: 1.0)
                    startAnimating(size, message: "Uploading image...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
                    interactor?.uploadWritingTest(testNumber: testNumber, testType: testType, testName: fileRequest, image: data!)
                }
            }
        } else {
            handleErrorMessage(message: "Select image to upload")
        }
        
    }
    
    var writingTypeName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        taskNotes.layer.borderWidth = 1
        taskNotes.layer.borderColor = borderColor.cgColor
        taskNotes.layer.cornerRadius = 4.0
        taskNotes.textContainerInset = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        taskNotes.delegate = self
        
        switch writingTypeName! {
            case Constants.WRITING_TYPE_UPLOAD:
                taskNotes.isHidden = true
                typeLabel.text = "Upload Script"
                break
            default:
                uploadContainer.isHidden = true
                typeLabel.text = "Type your essays here"
        }
        
        submitButton.isHidden = true
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "back-icon") , style: .plain, target: self, action: #selector(backAction(sender:)))
        customBackButton.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = customBackButton
        
        setUpTestNavigation()
        setUpDependencies()
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
        titleLabel1.text = questionGroup.groupName
        titleLabel2.text = questionGroup.groupName
        var body: String = questionGroup.questionDescription ?? ""
        let myNewLineStr = "\n"
        body = body.replacingOccurrences(of: "\\n", with: myNewLineStr)
        bodyLabel.text = body
        if !questionGroup.mockTestQuestion.isEmpty && questionGroup.mockTestQuestion[0].question != nil {
            let question = questionGroup.mockTestQuestion[0].question
            
            if (!answers.keys.contains(question.recordNo)) {
                answers[question.recordNo] = QuestionAnswer(questionFK: question.recordNo, answer: "", wordCount: 0)
            }
            
            if(!answers.keys.contains(question.recordNo)) {
                answers[question.recordNo] = QuestionAnswer(questionFK: question.recordNo, answer: "")
            }
            if question.sampleEssay != nil {
                //questionTxt.text = Html.fromHtml(questionGroup.mockTestQuestion[0].question.sampleEssay)
            }
            if images.keys.contains(question.recordNo) {
                fileImage.image = images[question.recordNo]
                captionLabel.isHidden = true
                cloudImage.isHidden = true
                fileImage.isHidden = false
            } else {
                captionLabel.isHidden = false
                cloudImage.isHidden = false
                fileImage.isHidden = true
            }
            
            if writingTypeName == Constants.WRITING_TYPE_WRITE {
                taskNotes.text = answers[question.recordNo]?.answer
            }
        }
        
        submitButton.isHidden = !isLast
        leftImageView.isHidden = isFirst
        rightImageView.isHidden = isLast
    }
    
    override func isNext(questionGroup: QuestionGroup)-> Bool {
        return !questionGroup.mockTestQuestion.isEmpty
    }

}

extension WritingTestViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let id = try? activeQuestionGroup?.mockTestQuestion[0].question.recordNo else {
            return
        }
        answers[id]?.answer = textView.text
    }
}
