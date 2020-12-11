
enum OperatorType: String, CaseIterable {
    case add = "+"
    case subtract = "-"
    case multiple = "*"
    case divide = "/"
}

struct Constants {
    static let equal = "="
    static let initialResultValue = "0"
}

class DecimalCalculator {
    var stack = Stack()
    var postfix = [String]()
    var resultValue: String = Constants.initialResultValue
    var operators: [String] = OperatorType.allCases.map {
        type -> String in return type.rawValue
    }
    
    func determineNumberOrOperator(_ input: String) {
        if isOperator(input) {
            handleOperator(input)
        } else if input == Constants.equal {
            popAllStackToPostfix()
            handlePostfix()
        } else {
            postfix.append(input)
        }
    }
    
    func handleOperator(_ input: String) {
        guard stack.isNotEmpty() else {
            stack.push(input)
            return
        }
        if isLowPriority(input) {
            popAllStackToPostfix()
            stack.push(input)
        } else {
            if isLowPriority(stack.peek()) {
                stack.push(input)
            } else {
                guard let popValue = stack.pop() else { return }
                postfix.append(popValue)
                stack.push(input)
            }
        }
    }
    
    func handlePostfix() {
        while postfix.isNotEmpty() {
            if operators.contains(postfix.first!) {
                let secondValue = stack.pop()
                let firstValue = stack.pop()
                let result = operate(secondValue: secondValue!, firstValue: firstValue!, calculatorOperator: postfix.first!)
                stack.push(result)
                postfix.removeFirst()
            } else {
                guard let number = postfix.first else { return }
                stack.push(number)
                postfix.removeFirst()
            }
        }
        guard let stackLastValue = stack.pop() else { return }
        resultValue = stackLastValue
    }
    
    func operate(secondValue: String, firstValue: String, calculatorOperator: String) -> String {
        let secondNumber = Int(secondValue) ?? 0
        let firstNumber = Int(firstValue) ?? 0
        
        switch calculatorOperator {
        case "+":
            return String(firstNumber + secondNumber)
        case "-":
            return String(firstNumber - secondNumber)
        case "*":
            return String(firstNumber * secondNumber)
        case "/":
            return String(firstNumber / secondNumber)
        default:
            return ""
        }
    }
    
    func isOperator(_ input: String) -> Bool {
        return operators.contains(input)
    }
    
    func isLowPriority(_ calculatorOperator: String?) -> Bool {
        guard calculatorOperator == OperatorType.add.rawValue
                || calculatorOperator == OperatorType.subtract.rawValue else {
            return false
        }
        return true
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
