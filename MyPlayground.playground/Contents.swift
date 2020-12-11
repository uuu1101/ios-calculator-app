// 2진 계산기만 수행할 수 있는 기능
// 두 수의 비트 AND, NAND, OR, NOR, XOR 연산
// 현재 수의 비트 NOT 연산, 비트 쉬프트 연산 (좌, 우) - 쉬프트하여 오버플로 된 자리는 버리고, 새로 생기는 자리는 0으로 채웁니다
// 2진 계산기는 정수만, 10진 계산기는 소수점을 포함한 실수를 모두 계산할 수 있습니다
// 계산기의 자릿수는 9자리로 제한합니다(오버플로 자릿수는 버림합니다)

struct Stack {
    var stack = [String]()
    
    mutating func push(value: String) {
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
}

enum OperatorType: String, CaseIterable, CustomStringConvertible {
    case add
    case subtract
    case multiple
    case divide
    
    var description: String {
        switch self {
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .multiple:
            return "*"
        case .divide:
            return "/"
        }
    }
    
    /*
    var priority: Int {
        switch self {
        case .multiple, .divide:
            return 100
        case .add, .subtract:
            return 10
        }
    }
    
    func isHighPriority(than input: OperatorType) -> Bool {
        let operatorPriority = self.priority - input.priority
        return operatorPriority >= 0
    }
 */
}

struct Constants {
    static let equal = "="
    static let initialResultValue = "0"
}

class DecimalCalculator {
    var stack = Stack()
    var postfix = [String]()
    var `operator`: [String] = OperatorType.allCases.map {
        type -> String in return "\(type)"
    }
    var resultValue: String = Constants.initialResultValue
    
    func isOperator(_ input: String) -> Bool {
        return `operator`.contains(input)
    }
    
    func determineNumberOrOperator(_ input: String) {
        if isOperator(input) {
            handleOperator(input)
        } else if input == Constants.equal {
            popAll()
        } else {
            postfix.append(input)
        }
    }
        
    func handleOperator(_ input: String) {
        if stack.isEmpty() {
            stack.push(value: input)
        } else {
            if input == OperatorType.add.rawValue || input == "-" {
                popAll()
                stack.push(value: input)
            } else {
                if stack.peek() == "+" || stack.peek() == "-" {
                    stack.push(value: input)
                } else {
                    postfix.append(stack.pop()!)
                    stack.push(value: input)
                }
            }
        }
    }
    
    func popAll() {
        while !stack.isEmpty() {
            postfix.append(stack.pop()!)
        }
    }
    
    func calculate() {
        while !postfix.isEmpty {
            print(stack)
            if !`operator`.contains(postfix.first!) {
                stack.push(value: postfix.first!)
                postfix.removeFirst()
            } else {
                let value1 = stack.pop()
                let value2 = stack.pop()
                let result = operate(v1: value1!, v2: value2!, op: postfix.first!)
                stack.push(value: result)
                postfix.removeFirst()
            }
        }
        resultValue = stack.pop()!
    }
    
    func operate(v1: String, v2: String, op: String) -> String {
        let newV1 = Int(v1) ?? 0
        let newV2 = Int(v2) ?? 0
        
        switch op {
        case "+":
            return String(newV2 + newV1)
        case "-":
            return String(newV2 - newV1)
        case "*":
            return String(newV2 * newV1)
        case "/":
            return String(newV2 / newV1)
        default:
            return ""
        }
    }
    
    func allClear() {
        stack.removeAll()
        postfix.removeAll()
    }
}


var cal = DecimalCalculator()

cal.main("2")
cal.main("-")
cal.main("10")
cal.main("/")
cal.main("5")
cal.main("*")
cal.main("6")
cal.main("+")
cal.main("4")
cal.main("=")



/*
 class Calculator {
 var currentValue: Double = 0
 
 func add(input: String) {
 guard let value = Double(input) else { return }
 currentValue += value
 }
 
 func subtract(input: String) {
 guard let value = Double(input) else { return }
 currentValue -= value
 }
 
 func multiply(input: String) {
 guard let value = Double(input) else { return }
 currentValue *= value
 }
 
 func initialize() {
 currentValue = 0
 }
 }
 
 class DecimaCalculator: Calculator {
 func divide(input: String) {
 guard let value = Double(input) else { return }
 currentValue /= value
 }
 }
 
 class BinaryCalculator: Calculator {
 override var currentValue: Double {
 didSet {
 return binaryResultValue = String(Int(currentValue), radix: 2)
 }
 }
 var binaryResultValue: String = ""
 
 func makeBinaryToDecimal(input: String) -> String {
 guard let intValue = Int(input, radix: 2) else { return "0" }
 let value = String(intValue)
 return value
 }
 
 override func add(input: String) {
 let value = makeBinaryToDecimal(input: input)
 super.add(input: value)
 }
 
 override func subtract(input: String) {
 let value = makeBinaryToDecimal(input: input)
 super.subtract(input: value)
 }
 
 override func multiply(input: String) {
 let value = makeBinaryToDecimal(input: input)
 super.multiply(input: value)
 }
 
 func and() {
 
 }
 
 func hand() {
 
 }
 
 func or() {
 
 }
 
 func nor() {
 
 }
 
 func xor() {
 
 }
 
 func not() {
 
 }
 
 func shiftleft() {
 
 }
 
 func shiftright() {
 
 }
 }
 
 */
