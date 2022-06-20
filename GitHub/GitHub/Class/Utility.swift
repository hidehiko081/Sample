//
//  Utility.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

class Utility {
    class func dateFromString(string: String?,
                              format: String) -> Date? {
        guard let dateString = string else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
    class func stringFromDate(date: Date,
                              format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    class func getComma(num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let number = "\(formatter.string(from: NSNumber(value: num)) ?? "")"
        
        return number
    }
}


