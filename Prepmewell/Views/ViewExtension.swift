//
//  ViewExtension.swift
//  Roadrunner
//
//  Created by ari on 17/07/2018.
//  Copyright © 2018 Roadrunner. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

@IBDesignable
class DesignableButton: UIButton {
    
    open var beginAnimationDuration: Double = 0.2
    
    /// End animation duration.
    open var endAnimationDuration: Double = 0.25
    
    @IBInspectable
    open var animateInteraction: Bool = false
    
    /// Should highlight on interaction.
    @IBInspectable
    open var highlightOnTouch: Bool = true
    
    /// Animation Scale.
    open var animationScale: CGFloat = 0.95
    
    /// Animation Spring velocity.
    open var initialSpringVelocity: Float = 6.0
    
    /// Animation Spring Damping.
    open var usingSpringWithDamping: Float = 0.2
    
    /// A flag which indicates if the button is in the middle of an animation.
    internal (set) open var isAnimating = false
    
    ///The function that is triggered once button is clicked (if set)
    open var onClickAction: ((DesignableButton)->Void)?
    
    /// Init with frame.
    ///
    /// - Parameter frame: The frame of the button.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// Init with coder
    ///
    /// - Parameter coder: NIB Coder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Setup function called from initializers.
    internal func setup(){
        addTarget(self, action: #selector(click), for: .touchUpInside)
        isExclusiveTouch = true
    }
    
    /// Called when adding the view.
    override open func didMoveToSuperview() {
        contentEdgeInsets = UIEdgeInsets(top: 0, left: frame.height * 0.4, bottom: 0, right: 0)
        layer.backgroundColor = color.cgColor
        if !isAnimating {
            layer.cornerRadius = cornerRadius
        }
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    /// Selector function
    @objc func click(){
        onClickAction?(self)
    }
    
    open override var isHighlighted: Bool{
        set{
            if highlightOnTouch {
                self.alpha = newValue ? 0.5 : 1
            }
            super.isHighlighted = newValue
        }
        get{
            return super.isHighlighted
        }
    }
    
    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    open var color: UIColor = .white{
        didSet{
            layer.backgroundColor = color.cgColor
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension DesignableButton{
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.animateInteraction{
            isAnimating = true
            UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                self.transform = CGAffineTransform(scaleX: self.animationScale, y: self.animationScale)
            }) { (complete) in
                self.isAnimating = false
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tap:UITouch = touches.first!
        let point = tap.location(in: self)
        if !self.bounds.contains(point){
            if self.animateInteraction{
                isAnimating = true
                UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                    self.transform = .identity
                }) { (complete) in
                    self.isAnimating = false
                }
            }
        }else{
            if self.animateInteraction{
                isAnimating = true
                UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                    self.transform = CGAffineTransform(scaleX: self.animationScale, y: self.animationScale)
                }) { (complete) in
                    self.isAnimating = false
                }
            }
        }
        super.touchesMoved(touches, with: event)
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.animateInteraction{
            isAnimating = true
            UIView.animate(withDuration: self.endAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(self.usingSpringWithDamping),
                           initialSpringVelocity: CGFloat(self.initialSpringVelocity),
                           options: .allowUserInteraction,
                           animations: {
                            self.transform = .identity
            }) { (complete) in
                self.isAnimating = false
            }
        }
        super.touchesEnded(touches, with: event)
        
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.animateInteraction{
            isAnimating = true
            UIView.animate(withDuration: self.endAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(self.usingSpringWithDamping),
                           initialSpringVelocity: CGFloat(self.initialSpringVelocity),
                           options: .allowUserInteraction,
                           animations: {
                            self.transform = .identity
            }) { (complete) in
                self.isAnimating = false
            }
        }
        super.touchesCancelled(touches, with: event)
    }
}


@IBDesignable
class DesignableLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
    
    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    open var color: UIColor = .white{
        didSet{
            layer.backgroundColor = color.cgColor
        }
    }
}

extension UIView{
    @IBInspectable
    open var elevate: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            //layer.shadowColor = Color().black.CGColor
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: newValue)
            layer.shadowRadius = newValue
            layer.shadowOpacity = 0.24
        }
    }
    
    func elevate(elevation: Double) {
        
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension CardView {
    
    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

public extension UIBarButtonItem {
    @IBInspectable var accEnabled: Bool {
        get {
            return isAccessibilityElement
        }
        set {
            isAccessibilityElement = newValue
        }
    }
    
    @IBInspectable var accLabelText: String? {
        get {
            return accessibilityLabel
        }
        set {
            accessibilityLabel = newValue
        }
    }
    
    var isHidden: Bool {
        get {
            return tintColor == UIColor.clear
        }
        set(hide) {
            if hide {
                isEnabled = false
                tintColor = UIColor.clear
            } else {
                isEnabled = true
                tintColor = nil // This sets the tinColor back to the default. If you have a custom color, use that instead
            }
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension Double {
    func toInt() -> Int? {
        if self > Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
extension Date {
//    var millisecondsSince1970:Int {
//        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//
//    init(milliseconds:Int) {
//        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
//    }
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
