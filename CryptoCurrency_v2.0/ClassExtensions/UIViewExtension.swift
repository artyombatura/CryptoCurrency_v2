//
//  UIViewExtension.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/11/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadiusStoryboard: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidthCustom: CGFloat {
        get { return self.layer.borderWidth }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorCustom: UIColor {
        get { return UIColor.black }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    public func makeShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
