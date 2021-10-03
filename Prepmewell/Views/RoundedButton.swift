//
//  RoundedButton.swift
//  Novucart
//
//  Created by thetaeo on 31/10/2018.
//  Copyright © 2018 Novucart. All rights reserved.
//

import UIKit

class RoundedButton: UIButton{
    
    override var backgroundColor: UIColor?{
        get{
            return UIColor(cgColor: layer.backgroundColor ?? UIColor.clear.cgColor)
        }set{
            layer.backgroundColor = newValue?.cgColor
        }
    }
    
    open var transformScale: CGFloat = 0.9
    
    private var didSetupDesign = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !didSetupDesign{
            didSetupDesign = true
            design()
        }
    }
    
    func design(){
        layer.cornerRadius = frame.size.height/2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 7
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
    }
    
    override var isHighlighted: Bool{
        set{
            UIView.animate(withDuration: 0.1) { [weak self] in
                let scale = self?.transformScale ?? 0.9
                self?.transform = newValue ? CGAffineTransform(scaleX: scale, y: scale) : .identity
            }
            super.isHighlighted = newValue
        }get{
            return super.isHighlighted
        }
    }
}
