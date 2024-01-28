//
//  Cell.swift
//  calcudoku
//
//  Created by cofincup on 2023/11/12.
//

import Foundation

class Cell {
    var strValue: String {
        get {
            return value == 0 ? "" : String(value)
        }
    }
    
    var value: Int = 0
    var x: Int
    var y: Int
    
    var relevantRules = [Rule]()
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
}
