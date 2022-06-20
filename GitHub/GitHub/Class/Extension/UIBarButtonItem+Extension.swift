//
//  UIBarButtonItem+Extension.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    class func setupBarButton(title: String,
                              delegate: Any?,
                              action: Selector) -> UIBarButtonItem {
        
        let button = UIBarButtonItem(title: title,
                                     style: .done,
                                     target: delegate,
                                     action: action)
        
        return button
    }
    
    class func setupBarButton(image: UIImage?,
                              delegate: Any?,
                              action: Selector) -> UIBarButtonItem {
        
        let button = UIBarButtonItem(image: image,
                                     style: .done,
                                     target: delegate,
                                     action: action)
        
        return button
    }
}
