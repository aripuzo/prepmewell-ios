//
//  BaseModalViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 09/04/2022.
//

import UIKit

class BaseModalViewController: UIViewController {
    
    let maxDimmedAlpha: CGFloat = 0.6
        
    open lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
        
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
            
        setupPanGesture()
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        animateDismissView()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
        
    func setupView() {
        view.backgroundColor = .clear
    }
        
    open func setupConstraints() {}
        
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
        
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
            
        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
            
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
            
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < getMaximumContainerHeight() {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
                
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < getDismissibleHeight() {
                self.animateDismissView()
            }
            else if newHeight < getDefaultHeight() {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(getDefaultHeight())
            }
            else if newHeight < getMaximumContainerHeight() && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(getDefaultHeight())
            }
            else if newHeight > getDefaultHeight() && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(getMaximumContainerHeight())
            }
        default:
            break
        }
    }
        
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
        
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
        
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
        
    func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.getDefaultHeight()
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    open func getDefaultHeight() -> CGFloat{
        return 400
    }
    
    open func getDismissibleHeight() -> CGFloat {
        return 200
    }
    
    open func getMaximumContainerHeight() -> CGFloat {
        return UIScreen.main.bounds.height - 64
    }
    
    open var currentContainerHeight: CGFloat = 400

}
