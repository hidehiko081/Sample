//
//  UIImage+Extension.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

extension UIImage {
    class func loadAsyncFromURL(_ urlString: String, callback: @escaping (UIImage?) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            let url = URL(string: urlString)
            
            do {
                let imgData = try Data(contentsOf: url!,options: NSData.ReadingOptions.mappedIfSafe)
                let img = UIImage(data:imgData);
                DispatchQueue.main.async(execute: {
                    callback(img)
                })
            } catch {
                print("Error: can't create image.")
                DispatchQueue.main.async(execute: {
                    callback(nil)
                })
            }
        }
    }
}
