// 2진 계산기만 수행할 수 있는 기능
// 두 수의 비트 AND, NAND, OR, NOR, XOR 연산
// 현재 수의 비트 NOT 연산, 비트 쉬프트 연산 (좌, 우) - 쉬프트하여 오버플로 된 자리는 버리고, 새로 생기는 자리는 0으로 채웁니다
// 2진 계산기는 정수만, 10진 계산기는 소수점을 포함한 실수를 모두 계산할 수 있습니다
// 계산기의 자릿수는 9자리로 제한합니다(오버플로 자릿수는 버림합니다)

struct Stack {
    var stack = [String]()
    
    mutating func push(_ value: String) {
        stack.append(value)
    }
    
    mutating func pop() -> String? {
        return stack.popLast()
    }
    
    func peek() -> String? {
        return stack.last
    }
    
    mutating func removeAll() {
        stack.removeAll()
    }
    
    func isEmpty() -> Bool {
        return stack.isEmpty
    }
    
    func isNotEmpty() -> Bool {
        return !stack.isEmpty
    }
}

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
        
        /* 위에 가드문이랑, 밑에 이프문이랑 같은건데 어떤게 나을지 봐주세요
         또 이렇게 하면 아까보다 뎁스가 좀 낮아지는데 어떨지...?! 아까 모양은 맨 밑에 있습니당.
         if stack.isEmpty() {
            stack.push(input)
            return
         }
         */
        
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
                let result = operate(secondValue: secondValue!, firstValue: firstValue!, operator: postfix.first!)
                stack.push(result)
                postfix.removeFirst()
            } else {
                stack.push(postfix.first!)
                postfix.removeFirst()
            }
        }
        resultValue = stack.pop()!
    }
    
    func operate(secondValue: String, firstValue: String, `operator`: String) -> String {
        let secondNumber = Int(secondValue) ?? 0
        let firstNumber = Int(firstValue) ?? 0
        
        switch `operator` {
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
    
    func isLowPriority(_ `operator`: String?) -> Bool {
        guard `operator` == OperatorType.add.rawValue
                || `operator` == OperatorType.subtract.rawValue else {
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

var cal = DecimalCalculator()

cal.determineNumberOrOperator("2")
cal.determineNumberOrOperator("-")
cal.determineNumberOrOperator("10")
cal.determineNumberOrOperator("/")
cal.determineNumberOrOperator("5")
cal.determineNumberOrOperator("*")
cal.determineNumberOrOperator("6")
cal.determineNumberOrOperator("+")
cal.determineNumberOrOperator("4")
cal.determineNumberOrOperator("=")

print(cal.resultValue)

/*
func handleOperator(_ input: String) {
    if stack.isEmpty() {
        stack.push(value: input)
    } else {
        if isLowPriority(input) {
            popAllStackToPostfix()
            stack.push(input)
        } else {
            if isLowPriority(stack.peek()!) {
                stack.push(input)
            } else {
                postfix.append(stack.pop()!)
                stack.push(input)
            }
        }
    }
}
*/
