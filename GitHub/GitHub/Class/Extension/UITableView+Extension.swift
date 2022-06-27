//
//  UITableView+Extension.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/25.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCellWithIdentifier>(indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
    }
}

protocol UITableViewCellWithIdentifier {
    static var identifier: String { get }
}

extension UITableViewCellWithIdentifier {
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
