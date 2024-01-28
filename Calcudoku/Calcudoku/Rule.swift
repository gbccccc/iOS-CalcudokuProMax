//
//  Rule.swift
//  calcudoku
//
//  Created by cofincup on 2023/11/12.
//

import Foundation

class Rule: NSObject {
    enum RuleType {
        case Differ
        case Add(Int)
        case Minus(Int)
        case Multiply(Int)
        case Divide(Int)
    }
    
    enum ExamineResult {
        case HasNil
        case Pass
        case Fail
    }
    
    var type: RuleType
    var cells = [Cell]()
    var status = ExamineResult.HasNil
    
    init(type: RuleType) {
        self.type = type
    }
    
    var ruleInfo: String {
        get {
            switch type {
            case .Add(let target):
                return String(target) + " +"
            case .Minus(let target):
                return String(target) + " -"
            case .Multiply(let target):
                return String(target) + " *"
            case .Divide(let target):
                return String(target) + " /"
            default:
                return ""
            }
        }
    }
    
    static func getType(calculationMark: String, target: Int) -> RuleType! {
        switch calculationMark{
        case "+":
            return .Add(target)
        case "-":
            return .Minus(target)
        case "*":
            return .Multiply(target)
        case "/":
            return .Divide(target)
        default:
            return nil
        }
    }
    
    func addCell(cell: Cell) {
        cells.append(cell)
    }
    
    func contains(checkingCell: Cell) -> Bool {
        for cell in cells {
            if checkingCell === cell {
                return true
            }
        }
        return false
    }
    
    func examine() {
        switch type  {
        case .Differ:
            break
        default:
            for cell in cells {
                if cell.value == 0 {
                    status = .HasNil
                    return
                }
            }
        }
        
        switch type {
        case .Differ:
            var helpingArray = [Int]()
            for cell in cells {
                if cell.value != 0 && helpingArray.contains(cell.value) {
                    status = .Fail
                    return
                }
                helpingArray.append(cell.value)
            }
            status = .Pass
            
        case .Add(let target):
            var sum = 0
            for cell in cells {
                sum += cell.value
            }
            status = sum == target ? .Pass : .Fail

        case .Minus(let target):
            var sum = 0
            for cell in cells {
                sum += cell.value
            }
            for cell in cells {
                if target == sum - 2 * cell.value{
                    status = .Pass
                    return
                }
            }
            status = .Fail
            
        case .Multiply(let target):
            var product = 1
            for cell in cells {
                product *= cell.value
            }
            status = product == target ? .Pass : .Fail
            
        case .Divide(let target):
            var product = 1
            for cell in cells {
                product *= cell.value
            }
            for cell in cells {
                if Double(target) == Double(cell.value * cell.value) / Double(product) {
                    status = .Pass
                    return
                }
            }
            status = .Fail
        }
    }
}
