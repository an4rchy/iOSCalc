//
//  ViewController.swift
//  Calculator
//
//  Created by Arjun Penemetsa on 2/10/15.
//  Copyright (c) 2015 Arjun Penemetsa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var userIsInTheMiddleOfTypingANumber: Bool  = false;
    let pi = M_PI
    

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        println("digit = \(digit)")

        if userIsInTheMiddleOfTypingANumber {
           display.text = display.text! + digit
           
        }
        else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber && operation != "."{
            enter()
        }
        switch operation {
        case "×": performOperation {$1 * $0}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$1 + $0}
        case "−": performOperation {$1 - $0}
        case "√": performOperation {sqrt($0)}
        case "sin": performOperation {sin($0)}
        case "cos": performOperation {cos($0)}
        case ".": if display.text!.rangeOfString(".") == nil {
            display.text = display.text! + "."
            
            }
        case "∏": performOperation(pi)
        case "C": display.text = "0"; operandStack.removeAll();
            history.text = "History:"
        default: break
            
        }
    }
    var operandStack = Array<Double>()
    
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }

    }
    func performOperation(operation: Double-> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
        
    }
    func performOperation(operation: Double){
        display.text = "\(pi)"
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        history.text = history.text! + ("\n\(displayValue)")
        println("\(operandStack)")
        println(history.text!)
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false;
        }
    }
}

