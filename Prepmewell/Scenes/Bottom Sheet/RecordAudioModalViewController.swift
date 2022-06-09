//
//  RecordAudioModalViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 17/05/2022.
//

import UIKit

class RecordAudioModalViewController: BaseModalViewController {

    var buttonText: String?
    var image: UIImage? = UIImage(named: "record-icon")
    
    var saveAction: () -> Void = { }
    var cancelAction: () -> Void = { }
    var recordAction: () -> Void = { }
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sound-waves")
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Record your answer"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Medium", size: 24)
        label.textAlignment = .center
        return label
    }()
    
    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Press and hold to record"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "Text2")
        label.font = UIFont(name:"Calibre-Regular", size: 16)
        label.numberOfLines = 6
        label.textAlignment = .center
        return label
    }()
    
    lazy var recordButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image
        //imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.recordClicked))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var actionButton: DesignableButton = {
        let view = DesignableButton()
        view.cornerRadius = 4
        view.color = UIColor(named: "Primary")!
        view.backgroundColor = UIColor(named: "Primary")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        view.widthAnchor.constraint(equalToConstant: 168).isActive = true
        view.setTitleColor(UIColor.white, for: .normal)
        view.setTitle("SAVE", for: .normal)
        view.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
        return view
    }()
    
    lazy var actionButton2: DesignableButton = {
        let view = DesignableButton()
        view.cornerRadius = 4
        view.color = UIColor(named: "Bg TextField")!
        view.backgroundColor = UIColor(named: "Bg TextField")
        view.borderWidth = 2.0
        view.borderColor = UIColor(named: "Border")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        view.widthAnchor.constraint(equalToConstant: 168).isActive = true
        view.setTitle("TRY AGAIN", for: .normal)
        view.titleLabel?.font = UIFont(name:"Calibre-Regular", size: 15)
        view.setTitleColor(UIColor(named: "Text1"), for: .normal)
        view.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        return view
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
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
        spacer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        let stackView = UIStackView(arrangedSubviews: [spacer, closeButton])
        stackView.axis = .horizontal
        return stackView
    }()
        
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [headerStackView, titleLabel, headerImage, recordButton, notesLabel, buttonStackView, spacer])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12.0
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [actionButton2, actionButton])
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.isHidden = true
        return stackView
    }()
    
    override func getDefaultHeight() -> CGFloat{
        return 500
    }
    
    override func getDismissibleHeight() -> CGFloat {
        return 250
    }
        
    override func setupConstraints() {
        // Add subviews
        currentContainerHeight = 500
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
    
    @objc func saveClicked(sender: UIButton!) {
        animateDismissView()
        saveAction()
    }
    
    @objc func cancelClicked(sender: UIButton!) {
        //animateDismissView()
        cancelAction()
    }
    
    @objc func recordClicked(sender: UIButton!) {
        //animateDismissView()
        recordAction()
    }
    
    @objc override func tapFunction(sender:UITapGestureRecognizer) {
        animateDismissView()
    }

}
