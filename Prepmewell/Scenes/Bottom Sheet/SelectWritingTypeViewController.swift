//
//  SelectWritingTypeViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 08/10/2021.
//

import UIKit
import BEMCheckBox

class SelectWritingTypeViewController: BaseModalViewController {
    
    var heading = "Choose writing test method."
    var image: UIImage? = UIImage(named: "error 1")
    var buttonText = "START TEST"
    
    var selectMenu: ((Int) -> ())?
    var buttonAction: () -> Void = { }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = heading
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Medium", size:24)
        return label
    }()
    
    func menuText(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "Text1")
        label.font = UIFont(name:"Calibre-Regular", size:16)
        label.numberOfLines = 0
        return label
    }
    
    var group = BEMCheckBoxGroup()
    
    func checkBox(tag: Int) -> BEMCheckBox {
        let checkbox = BEMCheckBox()
        checkbox.tintColor = UIColor(named: "Text2")!
        checkbox.onFillColor = UIColor(named: "Accent")!
        checkbox.onTintColor = .white
        checkbox.offFillColor = UIColor(named: "Light theme")!
        checkbox.onCheckColor = UIColor(named: "Check tint")!
        checkbox.tag = tag
        checkbox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 20).isActive = true
        group.addCheckBox(toGroup: checkbox)
        group.selectedCheckBox = checkbox
        return checkbox
    }
    
    func menuStackView(tag: Int, text: String) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [checkBox(tag: tag), menuText(text: text)])
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        return stackView
    }
    
    func space() -> UIView {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return spacer
    }
    
    lazy var actionButton: DesignableButton = {
        let view = DesignableButton()
        view.cornerRadius = 4
        view.color = UIColor(named: "Primary")!
        view.backgroundColor = UIColor(named: "Primary")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.setTitle(buttonText, for: .normal)
        view.titleLabel?.font = UIFont(name:"Calibre-Regular", size:15)
        view.setTitleColor(UIColor.white, for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
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
        
    lazy var contentStackView: UIStackView = {
        group.mustHaveSelection = true
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [headerStackView, titleLabel, menuStackView(tag: 0, text: "Type essay manually"), menuStackView(tag: 1, text: "Upload handwritten essay"), actionButton, spacer])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    override func getDefaultHeight() -> CGFloat{
        return 340
    }
    
    override func getDismissibleHeight() -> CGFloat {
        return 170
    }
        
    override func setupConstraints() {
        // Add subviews
        currentContainerHeight = 340
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

}
