//
//  ScheduleModalViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 08/04/2022.
//

import UIKit

class ScheduleModalViewController: BaseModalViewController {

    var heading: String?
    var subtitle: String?
    var body: String?
    var image: UIImage? = UIImage(named: "error 1")
    var buttonText: String?
    var buttonText2: String?
    
    var buttonAction: () -> Void = { }
    var buttonAction2: () -> Void = { }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = heading
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Medium", size:24)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = subtitle
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Regular", size:14)
        return label
    }()
    
    
    lazy var alarmImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        imageView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = body
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Regular", size:15)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actionButton: DesignableButton = {
        let view = DesignableButton()
        view.cornerRadius = 4
        view.color = UIColor(named: "Primary")!
        view.backgroundColor = UIColor(named: "Primary")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        view.setTitle(buttonText, for: .normal)
        view.titleLabel?.font = UIFont(name:"Calibre-Regular", size:15)
        view.setTitleColor(UIColor.white, for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return view
    }()
    
    lazy var actionButton2: DesignableButton = {
        let view = DesignableButton()
        view.cornerRadius = 4
        view.color = .white
        view.backgroundColor = .white
        view.borderWidth = 2.0
        view.borderColor = UIColor(named: "Border")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        view.setTitle(buttonText2, for: .normal)
        view.titleLabel?.font = UIFont(name:"Calibre-Regular", size:15)
        view.setTitleColor(UIColor(named: "Text1"), for: .normal)
        view.addTarget(self, action: #selector(buttonClicked2), for: .touchUpInside)
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
    
    lazy var subStitleStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [alarmImage, subtitleLabel, spacer])
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        return stackView
    }()
        
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [headerStackView, titleLabel, subStitleStackView, notesLabel, actionButton, actionButton2, spacer])
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
    
    @objc func buttonClicked(sender: UIButton!) {
        animateDismissView()
        buttonAction()
    }
    
    @objc func buttonClicked2(sender: UIButton!) {
        animateDismissView()
        buttonAction2()
    }

}
