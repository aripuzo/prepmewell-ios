//
//  ListeningTestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/22/21.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView

class ListeningTestViewController: TestViewController {
    
    override func didEndTest(response: TestResult) {
        stopAnimating()
        self.navigationController?.popViewController(animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ScreenID.TEST_HISTORY) as! TestHistoryViewController
        vc.testResult = response
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var questionsTable: UITableView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    var questions: [MockTestQuestion] = []
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    private var progressBarHighlightedObserver: NSKeyValueObservation?
    
    var isPlaying = false

    override func isNext(questionGroup: QuestionGroup)-> Bool {
        return !questionGroup.mockTestQuestion.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause() 
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    func setUpAudio() {
        let url = URL(string: "https://prepmewell-listiening.s3-us-west-2.amazonaws.com/music/\(questionResponse!.testName.replacingOccurrences(of: "Vol ", with: "Mock_")).mp3")
        
        let asset = AVAsset(url: url!)
        let playerItem = AVPlayerItem(asset: asset)
        if player == nil {
            player = AVPlayer(playerItem: playerItem)
        }
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 2), // used to monitor the current play time and update slider
            queue: DispatchQueue.global(), using: { [weak self] (progressTime) in
                    
            DispatchQueue.main.async {
                self!.playbackSlider.maximumValue = Float(self!.player?.currentItem?.asset.duration.seconds ?? 0)
                self!.playbackSlider.value = Float(progressTime.seconds)
                self!.timeLabel.text = "\(progressTime.seconds.stringFromTimeInterval()) \\ \(self!.player?.currentItem?.asset.duration.seconds.stringFromTimeInterval() ?? "00:00")"
            }
            
        })
            
        playbackSlider.value = 0
        playbackSlider.isContinuous = true
            
        playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ListeningTestViewController.playButtonTapped))
        playButton.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ListeningTestViewController.bubbleViewTapped))
        bubbleView.addGestureRecognizer(tap2)
            
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            
        player!.seek(to: targetTime)
            
        if player!.rate == 0 {
            player?.play()
        }
    }
    
    @objc func playButtonTapped(_ sender:UIButton){
        if !bubbleView.isHidden {
            bubbleView.isHidden = true
        }
        playAudio()
    }
    
    @objc func bubbleViewTapped(_ sender:UIButton){
        if !bubbleView.isHidden {
            bubbleView.isHidden = true
        }
        playAudio()
    }
    
    override func closeInfoDialog() {
        startTest()
    }

    override func startTest() {
//        playButton.isEnabled = false
//        binding.blocker.isGone = true
//        if !bubbleView.isHidden {
//            bubbleView.isHidden = true
//        }
//        playAudio()
        stopwatch()
    }
    
    func playAudio() {
        if !isPlaying {
            player?.play()
            playButton!.image = UIImage(named: "pause-circle")
            isPlaying = true
        } else {
            player?.pause()
            playButton!.image = UIImage(named: "play-circle")
            isPlaying = false
        }
    }
    
    override func bindActiveQuestion(questionGroup: QuestionGroup) {
        questions.removeAll()
        questions.append(contentsOf: questionGroup.mockTestQuestion)
        titleLabel1.text = questionGroup.groupName
        titleLabel2.text = questionGroup.groupName
        let body: String = questionGroup.questionDescription?.htmlToString ?? ""
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
        
        setUpAudio()
    }
    
    override func submitTest() {
        player = nil
        let arrayOfValues = Array(answers.values.map{ $0 })
        startAnimating(size, message: "Submitting test...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        interactor?.endTest(mockTestFK: mockTest!.recordNo, answers: arrayOfValues)
    }

}

extension ListeningTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionCell = self.questionsTable.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as! QuestionCell
        
        cell.noLabel.text = "\(indexPath.row + 1)"
        cell.setQuestion(mockTestQuestion: self.questions[indexPath.row])
        cell.setAnswer(answer: answers[self.questions[indexPath.row].question.recordNo]?.answer, questionFk: self.questions[indexPath.row].question.recordNo, testType: Constants.TEST_TYPE_LISTENING)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
