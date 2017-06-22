//
//  BounceButton.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 15/04/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit

@IBDesignable class BounceButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet{
            
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
            
            }, completion: nil)
        
        super.touchesBegan(touches, with: event)
    }
    
    
    }
