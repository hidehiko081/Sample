//
//  Translator.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

protocol Translator {
    associatedtype Input
    associatedtype Output
    
    func translate(_: Input) -> Output
}
