import Foundation

class ComputeResult
{
    var a: Operand?
    var b: Operand?
    var result: String
    
    init(_ a: Operand?, _ b: Operand?, _ result: String)
    {
        self.a = a
        self.b = b
        self.result = result
    }
}

class Bracket
{
    enum BracketType
    {
        case OPEN
        case CLOSE
    }
    
    var type: BracketType
    var equation: String
    var pos: String.Index
    
    init (_ type: BracketType, _ equation: String, _ pos: String.Index)
    {
        self.type = type
        self.equation = equation
        self.pos = pos
    }
}

enum SearchDir
{
    case RIGHT
    case LEFT
}

class Operand
{
    var start: String.Index
    var end: String.Index
    var equation: String
    var num: String
    
    init(start: String.Index, end: String.Index, equation: String)
    {
        self.start = start
        self.end = end
        self.equation = equation
        self.num = equation.substring(with: start..<end)
    }
    
    func doubleToString(result : Double) -> String
    {
        if ceil(result) == result { return String(Int(result)) }
        else
        {
            let formatter = NumberFormatter()
            
            formatter.maximumFractionDigits = 20
            formatter.minimumFractionDigits = 0
            
            formatter.numberStyle = .decimal
            return (formatter.string(from: NSNumber(value: result)))!
        }
    }
    func compute(operation: Character, operand: Operand) throws -> String
    {
        let a : Double? = Double(self.num)
        let b : Double? = Double(operand.num)
        
        if a == nil || b == nil
        {
            throw NSError(domain: "Invalid operand", code: 1)
        }
        switch operation
        {
        case "×":
            return doubleToString(result: a! * b!)
        case "÷":
            return doubleToString(result: a! / b!)
        case "+":
            return doubleToString(result: a! + b!)
        case "-":
            return doubleToString(result: a! - b!)
        default:
            return ""
        }
    }
}

class Calc
{
    var equation: String = ""
    
    static var operations: [String] = ["×", "÷", "+", "-"]
    
    func compute(str: String) throws -> ComputeResult
    {
        self.equation = str
        var right: Operand? = nil
        var left: Operand? = nil
        
        var indexOperation: String.Index? = nil
        
        while true
        {
            indexOperation = hasOperation()
            
            if indexOperation == nil { break }
            
            right = findNum(dir: .RIGHT, start: equation.index(after: indexOperation!))
            left  = findNum(dir: .LEFT, start: indexOperation!)
            
            
            if left!.num.count == 0 { break }
            
            let res: String = try left!.compute(operation: self.equation[indexOperation!], operand: right!)
            
            self.equation = String(self.equation.prefix(upTo: left!.start)) + String(res) + String(self.equation.suffix(from: right!.end))
        }
    
            return ComputeResult(right, left, self.equation)
    }
    
    func hasOperation() -> String.Index?
    {
        for i in equation.indices
        {
            if i.encodedOffset == 0 { continue }
            
            if equation[i] == "×" || equation[i] == "÷" { return i }
        }
        
        for i in equation.indices
        {
            if i.encodedOffset == 0 { continue }
            
            if equation[i] == "+" || equation[i] == "-" { return i }
        }
        
        return nil
    }
    
    func hasAnyOperation(st: String.Index, dir: SearchDir) -> String.Index?
    {
        if (dir == .RIGHT)
        {
            for i in equation.indices.suffix(from: st)
            {
                if (equation[i] == "×" || equation[i] == "÷" || equation[i] == "+" || equation[i] == "-") { return i }
            }
        }
        else
        {
            for i in equation.indices.prefix(upTo: st).reversed()
            {
                if (equation[i] == "×" || equation[i] == "÷" || equation[i] == "+" || equation[i] == "-") { return equation.index(after: i) }
            }
        }
        
        return nil
    }
    
    func findNum(dir: SearchDir, start: String.Index) -> Operand
    {
        if (dir == .RIGHT)
        {
            var nextOp = hasAnyOperation( st: equation[start] == "-" ? equation.index(after: start) : start, dir: dir )
            
            if nextOp == nil { nextOp = equation.endIndex }
            

            
            return Operand(start: start, end: nextOp!, equation : equation)
        }
        else
        {
            var prevOp = hasAnyOperation(st: start, dir: dir)
            
            if prevOp == nil && equation.first != "(" { prevOp = equation.startIndex }
            
            if prevOp == nil && equation.first == "(" { prevOp = equation.index(after: equation.startIndex )}
            
            prevOp = expandNum(dir: dir, start: prevOp!)
            
        
            return Operand(start: prevOp!, end: start, equation : equation)
            
        }
        
    }
    
    func expandNum(dir: SearchDir, start: String.Index) -> String.Index
    {
        if (dir == .LEFT && equation.startIndex != start)
        {
            if (equation[equation.index(before: start)] == "-") { return equation.index(before: start) }
        }
        
        return start
    }
    
    
    func computeWithBrackets(_ equation: String) throws -> ComputeResult
    {
        var eq = equation
        var brackets: [Bracket]? = [Bracket]()
        
        while true {
            brackets = getBrackets(eq)
            
            if brackets == nil { break }
            
            let from = eq.index(after: brackets![0].pos)
            let to = brackets![1].pos
            
            let neq = eq.substring(with: from..<to)
            let res = try compute(str: neq)
            
            eq = String(eq.prefix(upTo: eq.index(before: from) )) + String(res.result) + String(eq.suffix(from: eq.index(after: to)))
        }
        
        return try compute(str: eq)
    }
    
    func getBrackets(_ equation: String) -> [Bracket]?
    {
        var b = [Bracket]()
        var ret = [Bracket]()
        
        for i in equation.indices
        {
            if equation[i] == "("
            {
                b.append(Bracket(.OPEN, equation, i))
            } else
                
            if equation[i] == ")"
            {
                b.append(Bracket(.CLOSE, equation, i))
            }
        }
        
        if b.count > 1
        {
            for i in 1..<b.count
            {
                let end = b[i]
                let start = b[i - 1]
                
                if(end.type == .CLOSE && start.type == .OPEN)
                {
                    ret.append(start)
                    ret.append(end)
            
                    return ret
                }
            }
        }
        
        return nil
    }
}
