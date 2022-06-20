//
//  UIView+Extension.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit
import QuartzCore

extension UIView {
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
    
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: CGFloat {
        get {
            return CGFloat(self.layer.shadowOpacity)
        }
        set {
            self.layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return CGFloat(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
}
