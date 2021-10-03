//
//  QuestionGroupCell.swift
//  Prepmewell
//
//  Created by ari on 8/21/21.
//

import UIKit

class QuestionGroupCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var questionsTable: UITableView!
    
    var questions: [MockTestQuestion] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        questionsTable.register(UINib(nibName: "QuestionCell", bundle: nil),
                           forCellReuseIdentifier: QuestionCell.identifier)
        questionsTable.rowHeight = UITableView.automaticDimension
        questionsTable.estimatedRowHeight = 60
        
        questionsTable.delegate = self
        questionsTable.dataSource = self
    }
    
    
    var questionGroup: QuestionGroup?  {
        didSet {
            if let questionGroup = questionGroup {
                questions.removeAll()
                questions.append(contentsOf: questionGroup.mockTestQuestion)
                titleLabel.text = questionGroup.groupName
                bodyLabel.text = questionGroup.questionDescription
                questionsTable.reloadData()
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension QuestionGroupCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionCell = self.questionsTable.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as! QuestionCell
        
        cell.noLabel.text = "\(indexPath.row + 1)"
        
        //cell.setAnswer(answer: answers[self.questions[indexPath.row].recordNo]?.answer)
                
        cell.mockTestQuestion = self.questions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
