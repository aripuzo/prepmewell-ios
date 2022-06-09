//
//  SpeakingTestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/24/21.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView

enum SpeakingState {
    case normal
    case recording
    case playing
}

class SpeakingTestViewController: TestViewController, WritingTestDisplayLogic, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func uploadTestResponse(response: UploadTestResponse) {
        stopAnimating()
        answers[activeQuestion!.recordNo] = QuestionAnswer(questionFK: activeQuestion!.recordNo, answer: response.name)
        //"Recording save successfully"
        questionsTable.reloadData()
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
    
    var recordModelVC: RecordAudioModalViewController? = nil
    @IBOutlet weak var questionsTable: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var questions: [MockTestQuestion] = []
    var currentState: SpeakingState = .normal
    var activeQuestion: Question?
    
    var soundsNoteID: String!        // populated from incoming seque
    //var soundsNoteTitle: String!     // populated from incoming seque
    var soundURL: URL!            // store in CoreData
    var audioFileName: String!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var playingIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkMicrophoneAccess()

        questionsTable.register(UINib(nibName: "QuestionCell", bundle: nil),
                           forCellReuseIdentifier: QuestionCell.identifier)
        questionsTable.rowHeight = UITableView.automaticDimension
        questionsTable.estimatedRowHeight = 120
        
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
        initAudio()
    }
    
    func initAudio() {
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                    FileManager.SearchPathDomainMask.userDomainMask).first
                
        audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
        soundURL = audioFileURL       // Sound URL to be stored in CoreData
                
        // Setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
        } catch _ {
        }
                
        // Define the recorder setting
        let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32), AVSampleRateKey: 44100.0, AVNumberOfChannelsKey: 2 ]
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
                
        audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
    }
    
    func startRecording() {
        print("Record called")
        // Stop the audio player before recording
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
                
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                        
                do {
                    try audioSession.setActive(true)
                } catch _ {
                }
                        
                // Start recording
                recorder.record()
                        
                recordModelVC?.notesLabel.text = "Recording .."
                
                recordModelVC?.recordButton.image = UIImage(named: "record-icon")
                        
                //speakingTestViewModel.currentState.set(STATE_RECORD)
                        
            } else if recorder.isRecording {
                audioRecorder?.stop()
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(false)
                } catch _ {
                }
            }
        }
    }
    
    func startPlayer() {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                if audioPlayer?.isPlaying == true {
                    audioPlayer?.stop()
                }
                else {
                    recordModelVC?.notesLabel.text = "Playing.."
                    audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                    audioPlayer?.delegate = self
                    audioPlayer?.play()
                    recordModelVC?.recordButton.image = UIImage(named: "record-pause")
                }
            }
        }
    }
    
    func startPlayer2(url: String) {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                if audioPlayer?.isPlaying == true {
                    audioPlayer?.stop()
                    playingIndex = nil
                }
                else {
                    if audioPlayer == nil {
                        audioPlayer = try? AVAudioPlayer(contentsOf: URL(string: url)!)
                        audioPlayer?.delegate = self
                        audioPlayer?.play()
                    }
                }
                questionsTable.reloadData()
            }
        }
    }
    
    override func closeInfoDialog() {
        startTest()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordModelVC?.notesLabel.text = "Playing Completed"
        recordModelVC?.recordButton.image = UIImage(named: "record-play")
            
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if flag {
                recordModelVC?.buttonStackView.isHidden = false

                recordModelVC?.recordButton.image = UIImage(named: "record-play")
                recordModelVC?.notesLabel.text = "Play recording"
                currentState = .playing
            } else {
                currentState = .recording
                recordModelVC?.recordButton.image = UIImage(named: "record-icon")
            }
    }
    
    func soundSaveAction(question: Question) {
        activeQuestion = question;
        let data = NSData (contentsOf: soundURL!)
        startAnimating(size, message: "Uploading file...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        interactor?.uploadSpeakingTest(file: data! as Data, fileName: audioFileName)
    }
    
    func checkMicrophoneAccess() {
        // Check Microphone Authorization
        switch AVAudioSession.sharedInstance().recordPermission {
            
            case AVAudioSession.RecordPermission.granted:
                print(#function, " Microphone Permission Granted")
                break
                
            case AVAudioSession.RecordPermission.denied:
                // Dismiss Keyboard (on UIView level, without reference to a specific text field)
                UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to:nil, from:nil, for:nil)
            
                handleErrorMessage(message: "Prepmewell is Not Authorized to Access the Microphone!")
                
                let alertVC = UIAlertController(title: "Microphone Error!", message: "Prepmewell is Not Authorized to Access the Microphone!", preferredStyle: UIAlertController.Style.alert)
            
                alertVC.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {_ in
                    
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        }
                    } // end dispatchQueue
                    
                }))
            
                alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                
                self.present(alertVC, animated: true, completion: nil)
                return
                
            case AVAudioSession.RecordPermission.undetermined:
                print("Request permission here")
                // Dismiss Keyboard (on UIView level, without reference to a specific text field)
                UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to:nil, from:nil, for:nil)
                
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    // Handle granted
                    if granted {
                        print(#function, " Now Granted")
                    } else {
                        print("Pemission Not Granted")
                        
                    } // end else
                })
            @unknown default:
                print("ERROR! Unknown Default. Check!")
        } // end switch
    }
    
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }

    // Helper function inserted by Swift migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func showRecordDialog(question: Question) {
        currentState = .recording
        if recordModelVC == nil {
            recordModelVC = RecordAudioModalViewController()
        }
        recordModelVC?.buttonStackView.isHidden = true
        recordModelVC?.recordButton.image = UIImage(named: "record-icon")
        recordModelVC!.modalPresentationStyle = .overCurrentContext
        recordModelVC!.saveAction = {
            self.soundSaveAction(question: question)
        }
        recordModelVC!.cancelAction = { [self] in
            currentState = .normal
            recordModelVC?.buttonStackView.isHidden = true
        }
        recordModelVC!.recordAction = { [self] in
            if currentState == .recording {
                self.startRecording()
            } else if currentState == .playing {
                self.startPlayer()
            }
        }
        self.present(recordModelVC!, animated: false)
    }
    
    override func bindActiveQuestion(questionGroup: QuestionGroup) {
        questions.removeAll()
        questions.append(contentsOf: questionGroup.mockTestQuestion)
        titleLabel1.text = questionGroup.groupName
        titleLabel2.text = questionGroup.groupName
        
        var body: String = questionGroup.questionDescription ?? ""
        let myNewLineStr = "\n"
        body = body.replacingOccurrences(of: "\\n", with: myNewLineStr)
        bodyLabel.text = body
        
        questionsTable.reloadData()
        
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

    
    override func submitTest() {
        let arrayOfValues = Array(answers.values.map{ $0 })
        startAnimating(size, message: "Submitting test...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        interactor?.endTest(mockTestFK: mockTest!.recordNo, answers: arrayOfValues)
    }
    
    override func startTest() {
        stopwatch()
    }

}

extension SpeakingTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionCell = self.questionsTable.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as! QuestionCell
        
        let question = self.questions[indexPath.row]
        let answer = answers[question.question.recordNo]?.answer
        
        cell.noLabel.text = "\(indexPath.row + 1)"
        cell.setQuestion(mockTestQuestion: question)
        cell.setAnswer(answer: answer, questionFk: question.question.recordNo, testType: Constants.TEST_TYPE_SPEAKING, isPlaying: self.playingIndex == indexPath.row)
        cell.recordAction = {
            if answer != nil && !answer!.isEmpty {
                self.startPlayer2(url: answer!)
            } else {
                self.showRecordDialog(question: question.question)
            }
        }
        cell.deleteAction = {
            let alert = UIAlertController(title: "Delete Answer", message: "Are you sure you want to delete recording?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                self.answers[question.question.recordNo]?.answer = nil
                self.questionsTable.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
