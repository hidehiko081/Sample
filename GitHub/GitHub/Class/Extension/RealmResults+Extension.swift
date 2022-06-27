//
//  Realm+Extension.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/27.
//

import Foundation
import RealmSwift

extension Results {
  var list: List<Element> {
    reduce(.init()) { list, element in
      list.append(element)
      return list
    }
  }
}
