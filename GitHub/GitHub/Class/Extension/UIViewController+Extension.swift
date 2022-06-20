//
//  UIViewController+Extension.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
