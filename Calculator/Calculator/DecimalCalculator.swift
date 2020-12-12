import Foundation

class DecimalCalculator {
    var stack = Stack()
    var postfix = [String]()
    var resultValue: String = Constants.zero
    var operators: [String] = DecimalOperatorType.allCases.map {
        type -> String in return type.rawValue
    }
    
    func handleInput(_ input: String) {
        if isOperator(input) {
            handleOperator(input)
        } else if input == Constants.equal {
            popAllStackToPostfix()
            handlePostfix()
            allClear()
        } else {
            postfix.append(input)
        }
    }
    
    func handleOperator(_ input: String) {
        guard stack.isNotEmpty() else {
            stack.push(input)
            return
        }
        guard let operatorType = DecimalOperatorType(rawValue: input),
              let peekedValue = stack.peek(),
              let peekedOperator = DecimalOperatorType(rawValue: peekedValue) else { return }
        
        if operatorType.isHighPriority(than: peekedOperator) {
            stack.push(input)
        } else if operatorType.isLowPriority(than: peekedOperator) {
            popAllStackToPostfix()
            stack.push(input)
        } else {
            guard let popValue = stack.pop() else { return }
            postfix.append(popValue)
            stack.push(input)
        }
    }
    
    func handlePostfix() {
        while postfix.isNotEmpty() {
            guard let postfixValue = postfix.first else { return }
            if operators.contains(postfixValue) {
                // not, shift
                // operate(calculatorOperator: calculatorOperator, firstValue: firstValue)
                // 아닌경우
                guard let calculatorOperator = DecimalOperatorType(rawValue: postfixValue),
                      let secondValue = stack.pop(),
                      let firstValue = stack.pop() else { return }
                let result = operate(calculatorOperator: calculatorOperator, firstValue: firstValue, secondValue: secondValue)
                stack.push(result)
                postfix.removeFirst()
            } else {
                guard let number = postfix.first else { return }
                stack.push(number)
                postfix.removeFirst()
            }
        }
        guard let stackLastValue = stack.pop() else { return }
        resultValue = handleDigit(stackLastValue)
    }
    
    func operate(calculatorOperator: DecimalOperatorType, firstValue: String, secondValue: String = Constants.zero) -> String {
        guard let firstNumber = Double(firstValue),
              let secondNumber = Double(secondValue) else { return Constants.zero }
        
        switch calculatorOperator {
        case .add:
            return String(firstNumber + secondNumber)
        case .subtract:
            return String(firstNumber - secondNumber)
        case .multiple:
            return String(firstNumber * secondNumber)
        case .divide:
            return String(firstNumber / secondNumber)
        }
    }
    
    func handleDigit(_ fullNumber: String) -> String {
        var result = Constants.zero
        let frountNumber = fullNumber.components(separatedBy: Constants.dot)[0]
        
        if frountNumber.count > Constants.maxLength {
            let offsetLength = frountNumber.count - Constants.maxLength
            let startIndex = frountNumber.index(frountNumber.startIndex, offsetBy: offsetLength)
            result = String(frountNumber[startIndex...])
        } else {
            let offsetLength = fullNumber.count > Constants.maxLength  ? Constants.maxLength : fullNumber.count - 1
            let endIndex = fullNumber.index(fullNumber.startIndex, offsetBy: offsetLength)
            result = String(fullNumber[...endIndex])
        }
        if result.hasSuffix(Constants.zero) { result.removeLast() }
        if result.hasSuffix(Constants.dot) { result.removeLast() }
        return result
    }
    
    func isOperator(_ input: String) -> Bool {
        return operators.contains(input)
    }
    
    func popAllStackToPostfix() {
        while !stack.isEmpty() {
            postfix.append(stack.pop()!)
        }
    }
    
    func allClear() {
        stack.removeAll()
        postfix.removeAll()
    }
}

extension Array {
    func isNotEmpty() -> Bool {
        return !isEmpty
    }
}
