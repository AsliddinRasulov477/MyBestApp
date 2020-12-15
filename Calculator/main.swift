import Foundation

enum SearchDir
{
    case RIGHT
    case LEFT
}


class Operand
{
    var start: String.Index
    var end: String.Index
    var eq: String
    var num: String

    init(start: String.Index, end: String.Index, eq: String)
    {
        self.start = start
        self.end = end
        self.eq = eq
        self.num = eq.substring(with: start..<end)
    }

    func compute(operation: Character, right: Operand) -> Double
    {
        let a : Double = Double(self.num)!
        let b : Double = Double(right.num)!

        switch operation
        {
        case "*":
            return a * b
        case "/":
            return a / b
        case "+":
            return a + b
        case "-":
            return a - b
        default:
            return 0
        }
    }
}

class Calc
{
    var eq: String = ""
    
    static var operations: [String] = ["*", "/", "+", "-"]

    func compute(str: String) -> String
    {
        self.eq = str

        var indexOperation: String.Index? = nil

        while true
        {
            indexOperation = hasOperation()
        
            if indexOperation == nil { break }

            let right : Operand = findNum(dir: .RIGHT, start: eq.index(after: indexOperation!))
            let left  : Operand = findNum(dir: .LEFT, start: indexOperation!)

            if left.num.count == 0 { break }

            let res: Double = left.compute(operation: self.eq[indexOperation!], right: right)

            self.eq = String(self.eq.prefix(upTo: left.start)) + String(res) + String(self.eq.suffix(from: right.end))
        }

        print(self.eq)
        
        return self.eq
    }

    func hasOperation() -> String.Index?
    {
        
        
        for i in eq.indices
        {
            if i.encodedOffset == 0
            {
                continue
            }

            if eq[i] == "*" || eq[i] == "/"
            {
                return i
            }
        }

        for i in eq.indices
        {
            if (i.encodedOffset == 0)
            {
                continue
            }

            if (eq[i] == "+" || eq[i] == "-")
            {
                return i
            }
        }

        return nil
    }

    func hasAnyOperation(st: String.Index, dir: SearchDir) -> String.Index?
    {
        if (dir == .RIGHT)
        {
            for i in eq.indices.suffix(from: st)
            {
                if (eq[i] == "*" || eq[i] == "/" || eq[i] == "+" || eq[i] == "-")
                {
                    return i
                }
            }
        }
        else
        {
            for i in eq.indices.prefix(upTo: st).reversed()
            {
                if (eq[i] == "*" || eq[i] == "/" || eq[i] == "+" || eq[i] == "-")
                {
                    return eq.index(after: i)
                }
            }
        }

        return nil
    }

    func findNum(dir: SearchDir, start: String.Index) -> Operand
    {
        if (dir == .RIGHT)
        {
            let nextOp = hasAnyOperation(
                    st: eq[start] == "-" ? eq.index(after: start) : start, dir: dir ) ?? eq.endIndex

            return Operand(start: start, end: nextOp, eq: eq)
        }
        else
        {
            var prevOp = hasAnyOperation(st: start, dir: dir) ?? eq.startIndex
            prevOp = expandNum(dir: dir, start: prevOp)

            return Operand(start: prevOp, end: start, eq: eq)
        }

    }

    func expandNum(dir: SearchDir, start: String.Index) -> String.Index
    {
        if (dir == .LEFT && eq.startIndex != start)
        {
            if (eq[eq.index(before: start)] == "-")
            {
                return eq.index(before: start)
            }
        }

        return start
    }
}

var calc = Calc()

calc.compute(str: "2*2+3/3--2")


