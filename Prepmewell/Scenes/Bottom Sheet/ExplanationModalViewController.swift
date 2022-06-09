//
//  ExplanationModalViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 10/04/2022.
//

import UIKit

class ExplanationModalViewController: BaseModalViewController {
    
    var question: MockTestResultDetail?
    var image: UIImage? = UIImage(named: "error 1")
    
    lazy var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Question:"
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Semibold", size:24)
        return label
    }()
    
    func subHeader(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Semibold", size:18)
        return label
    }
    
    func body(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Regular", size:15)
        label.numberOfLines = 0
        return label
    }
    
    func space() -> UIView {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return spacer
    }
    
    lazy var questionSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Which section contains the following information?"
        label.textColor = UIColor(named: "Text2")
        label.font = UIFont(name:"Calibre-Regular", size:14)
        return label
    }()
    
    lazy var closeButton: CardView = {
        let view = CardView()
        view.cornerRadius = 20
        view.backgroundColor = UIColor(named: "Light theme")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(closeIcon)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        view.addGestureRecognizer(tap)
        closeIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        closeIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    lazy var closeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "close.png")
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var headerStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [spacer, closeButton])
        stackView.axis = .horizontal
        return stackView
    }()
        
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [headerStackView, questionTitleLabel, questionSubtitleLabel, body(text: question!.question.questionName!), space(), subHeader(text: "Correct answer"), body(text: question!.correctAnswer!), space(), subHeader(text: "Location in passage"), body(text: question!.question.sampleEssay ?? ""), space(), subHeader(text: "Explanation"), body(text: question!.question.explanation!), spacer])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
        
    // Constants
    override func getDefaultHeight() -> CGFloat{
        return 600
    }
    
    override func getDismissibleHeight() -> CGFloat {
        return 300
    }
        
    override func setupConstraints() {
        // Add subviews
        currentContainerHeight = 600
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
            
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
            
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
            
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: getDefaultHeight())
            
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: getDefaultHeight())
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }

}
