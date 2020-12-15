import UIKit

class Calculator: UIViewController
{
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var buttonTitle = "" , action = "0" , operand = "" , plusminusLabel = ""

    var open = 0 , close = 0 , label = 1  , k = 0
    
    var memory = 0.0
    
    var forBracket = true , brackets = true , dot = false , dotNumbers = false , plusminus = true
    
    fileprivate func compute()
    {
        do
        {
            let result = try calc.computeWithBrackets(label1.text!)
            
            label2.text = result.result
            
            while label2.text?.first == "("
            {
                label2.text?.removeFirst()
            }
        } catch   { }
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
    @IBAction func numbers(_ sender: UIButton)
    {
        if label1.text == "0"
        {
            label1.text = ""
        }
        if label == 1 && action == ""
        {
            label1.text = "" ; open = 0 ; close = 0
        }

        buttonTitle = sender.currentTitle!

        if label1.text?.last == ")"
        {
            label1.text = label1.text! + "×" + buttonTitle
        }
        else
        {
            label1.text = label1.text! + buttonTitle
        }
        if open == close
        {
            compute()
        }
        
        if !dotNumbers
        {
            dot = false
        }
        action = "" ; forBracket = false
        label = 0 ; k = 0
    }
    @IBAction func actions(_ sender: UIButton)
    {
        if label1.text?.last != "(" && k != 1
        {
            if label1.text?.last == "+" || label1.text?.last == "-"
            {
                label1.text?.removeLast()
            } else
            if label1.text?.last == "×" || label1.text?.last == "÷"
            {
                label1.text?.removeLast()
            }
            buttonTitle = sender.currentTitle! ; label2.text = ""
            label1.text = label1.text! + buttonTitle
            forBracket = true ; dot = false ; plusminus = true
            label = 0 ;
            action = buttonTitle ; operand = ""
        }
    }
    @IBAction func equality(_ sender: UIButton)
    {
        if label2.text != ""
        {
            label1.text = label2.text
            label = 1 ; k = 0
            dot = false
        }
        
        label2.text = "" ;
    }
    @IBAction func clearButton(_ sender: UIButton)
    {
        buttonTitle = "" ; label1.text = "0" ; label2.text = "" ;  operand = "" ; plusminusLabel = ""
        action = "" ; open = 0 ; close = 0 ; label = 1 ; k = 0 ; memory = 0.0
        forBracket = true ; brackets = true ; dot = false ; dotNumbers = false ; plusminus = true
    }
    
    @IBAction func brackets(_ sender: UIButton)
    {
        if label1.text == "0"
        {
            label1.text = ""
        }
        if label1.text == "" || label1.text?.last == "("
        {
            label1.text = label1.text! + "(" ; open += 1; label = 0
        } else
        if label1.text?.last == "+" || label1.text?.last == "-"
        {
            label1.text = label1.text! + "(" ; open += 1
        } else
        if label1.text?.last == "×" || label1.text?.last == "÷"
        {
            label1.text = label1.text! + "(" ; open += 1
        } else
        if label1.text?.last == ")" && open == close
        {
            label1.text = label1.text! + "×(" ; open += 1
        } else
        if label1.text?.last == ")" && open != close
        {
            label1.text = label1.text! + ")" ; close += 1
        } else
        {
            if open == close
            {
                label1.text = label1.text! + "×(" ; open += 1
            } else
            {
                label1.text = label1.text! + ")" ; close += 1
            }
        }
        if open == close && label1.text!.last == ")"
        {
            compute()
        }
        dot = false
        k = 0 ; label = 0
    }
    
    @IBAction func doT(_ sender: UIButton)
    {
        if !dot
        {
            if label1.text?.last == "+" || label1.text?.last == "-"
            {
                label1.text = label1.text! + "0."
            } else
            if label1.text?.last == "×" || label1.text?.last == "÷" || label1.text?.last == "("
            {
                label1.text = label1.text! + "0."
            } else
            if label1.text?.last == ")"
            {
                label1.text = label1.text! + "×0."
            } else
            if label == 1
            {
                label1.text = "0."
            } else
            {
                label1.text = label1.text! + "." ; brackets = false
            }
        }
        dot = true ; dotNumbers = true
        label = 0 ; k = 0
    }
    @IBAction func deleteLast(_ sender: UIButton)
    {
        if label1.text?.last == ")" { close -= 1 }
        if label1.text?.last == "(" { open -= 1 }
        
        label1.text?.removeLast()
        
        if label1.text?.last == "+" || label1.text?.last == "-" || open != close
        {
            label2.text = ""
        } else
        if label1.text?.last == "×" || label1.text?.last == "÷" || label1.text?.last == "("
        {
            label2.text = ""
        }
        else
        {
            compute() ; action = ""
        }
        if label1.text == "" { label1.text = "0" }
        
        if label1.text?.last != "." { dot = false }
        
        plusminus = true ; k = 0
        
        if label1.text!.last == "-"
        {
            label1.text?.removeLast()
            if label1.text!.last == "(" { k = 1 }
        }
    }
    @IBAction func plusminus(_ sender: UIButton)
    {
        if plusminus
        {
            if label1.text == "0"
            {
                label1.text = ""
            }
            if label1.text?.first == "-"
            {
                label1.text?.removeFirst()
                plusminus = true
            } else
            if label1.text == ""
            {
                label1.text = "(-" ; open += 1; label = 0
                plusminus = false
            } else
            if label1.text?.last == ")"
            {
                label1.text = label1.text! + "×(-" ; open += 1
                plusminus = false
            } else
            if label1.text?.last == "(" || label1.text?.last == "+" || label1.text?.last == "-"
            {
                label1.text = label1.text! + "(-" ; open += 1
                plusminus = false
            } else
            if label1.text?.last == "×" || label1.text?.last == "÷"
            {
                label1.text = label1.text! + "(-" ; open += 1
                plusminus = false
            } else
            if label == 1
            {
                label1.text = "(-" + label1.text! ; open += 1 ; compute(); label = 0
                plusminus = false
            } else
            if label1.text!.last == "-"
            {
                label1.text?.removeLast()
                if label1.text!.last == "("
                {
                    k = 1
                }
                plusminus = false
            } else
            {
                while !(label1.text?.last == "+" || label1.text?.last == "-" || label1.text?.last == "×" ||
                        label1.text?.last == "÷" || label1.text == "" || label1.text?.last == "(")
                {
                    let a = label1.text!.removeLast() ; operand += a.description
                }
                label1.text = label1.text! + "(-" + operand.reversed() ; open += 1
                plusminus = false
            }
            k = 0
            
        } else
        {
            var i = label1.text!.index(before: label1.text!.endIndex)
        
            while true
            {
                if label1.text![i] == "-"
                {
                    label1.text?.remove(at: i)
                    label1.text?.remove(at: label1.text!.index(before: i))
                    break
                }
                i = (label1.text?.index(before: i))!
            }
            plusminus = true ; operand = ""  ; open -= 1 ; k = 0
        }
    }
    
    @IBAction func memoryplus(_ sender: UIButton)
    {
        if label2.text != ""
        {
            memory += Double(label2.text!)!
        }
    }
    @IBAction func memoryminus(_ sender: UIButton)
    {
        if label2.text != ""
        {
            memory -= Double(label2.text!)!
        }
    }
    @IBAction func useMemory(_ sender: UIButton)
    {
        if memory != 0 {
            if label1.text == "0" { label1.text = "" }
            label1.text = label1.text! + doubleToString(result: memory)
            compute()
        }
    }
    
    var calc = Calc()
    
}



