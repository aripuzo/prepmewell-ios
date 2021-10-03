//
//  ListeningTestViewController.swift
//  Prepmewell
//
//  Created by ari on 8/22/21.
//

import UIKit
import AVFoundation

class ListeningTestViewController: TestViewController {
    
    @IBOutlet weak var questionsTable: UITableView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    var questions: [MockTestQuestion] = []
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?

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

        setUpTestNavigation()
        setUpDependencies()
        registerAnswerTextObsever()
        interactor?.getQuestions(mockTestFK: mockTest.recordNo)
    }
    
    func setUpAudio() {
        let url = URL(string: "https://prepmewell-listiening.s3-us-west-2.amazonaws.com/music/\(questionResponse!.testName.replacingOccurrences(of: "Vol ", with: "Mock_"))/.mp3")
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
            
//        let playerLayer=AVPlayerLayer(player: player!)
//        playerLayer.frame = CGRect(x:0, y:0, width:10, height:50)
//        self.view.layer.addSublayer(playerLayer)
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 2), // used to monitor the current play time and update slider
            queue: DispatchQueue.global(), using: { [weak self] (progressTime) in
                    
            DispatchQueue.main.async {
                self!.playbackSlider.maximumValue = Float(self?.player!.currentItem!.asset.duration.seconds ?? 0.0)
                self!.playbackSlider.value = Float(progressTime.seconds)
            }
            
        })
            
            
            // Add playback slider
            
        playbackSlider.minimumValue = 0
            
            
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
            
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
            
        //playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        // playbackSlider.addTarget(self, action: "playbackSliderValueChanged:", forControlEvents: .ValueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ListeningTestViewController.playButtonTapped))
        playButton.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ListeningTestViewController.bubbleViewTapped))
        bubbleView.addGestureRecognizer(tap2)
            
    }
    
    @objc func playButtonTapped(_ sender:UIButton){
        print("got here")
        if !bubbleView.isHidden {
            bubbleView.isHidden = true
        }
        if player?.rate == 0 {
            player!.play()
            playButton!.image = UIImage(named: "pause-circle")
        }
    }
    
    @objc func bubbleViewTapped(_ sender:UIButton){
        print("got here")
        if !bubbleView.isHidden {
            bubbleView.isHidden = true
        }
    }
    
    override func closeInfoDialog() {
        startTest()
    }

    override func startTest() {
        //stopwatch()
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

}

extension ListeningTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionCell = self.questionsTable.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as! QuestionCell
        
        cell.noLabel.text = "\(indexPath.row + 1)"
        
        cell.setAnswer(answer: answers[self.questions[indexPath.row].question.recordNo]?.answer, questionFk: self.questions[indexPath.row].question.recordNo)
                
        cell.mockTestQuestion = self.questions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
