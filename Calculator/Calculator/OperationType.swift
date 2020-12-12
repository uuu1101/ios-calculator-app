//
//  OperationType.swift
//  Calculator
//
//  Created by 임리나 on 2020/12/12.
//

enum DecimalOperatorType: String, CaseIterable {
    case add = "+"
    case subtract = "-"
    case multiple = "*"
    case divide = "/"
    
    var priority: Int {
        switch self {
        case .multiple, .divide:
            return 100
        case .add, .subtract:
            return 10
        }
    }
    
    func isHighPriority(than input: DecimalOperatorType) -> Bool {
        let operatorPriority = self.priority - input.priority
        return operatorPriority > 0
    }
    
    func isLowPriority(than input: DecimalOperatorType) -> Bool {
        let operatorPriority = self.priority - input.priority
        return operatorPriority < 0
    }
}

enum BinaryOperatorType: String, CaseIterable {
    case add = "+"
    case subtract = "-"
    case and = "&"
    case nand = "~&"
    case or = "|"
    case nor = "~|"
    case xor = "^"
    case not = "~"
    case leftShift = "<<"
    case rightShift = ">>"
    
    var priority: Int {
        switch self {
        case .not:
            return 100
        case .add, .subtract:
            return 90
        case .leftShift, .rightShift:
            return 80
        case .and:
            return 70
        case .xor:
            return 60
        case .or:
            return 50
        case .nand, .nor: // 여기 우선 순위
            return 0
        }
    }
    
    func isHighPriority(than input: BinaryOperatorType) -> Bool {
        let operatorPriority = self.priority - input.priority
        return operatorPriority > 0
    }
    
    func isLowPriority(than input: BinaryOperatorType) -> Bool {
        let operatorPriority = self.priority - input.priority
        return operatorPriority < 0
    }
}
