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
    var brain = CalculatorBrain()

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        println("sender's current title is \(sender.currentTitle!)")
        let digit = sender.currentTitle!
        if sender.currentTitle! == "∏"{
            if display.text! != "0.0" {
            enter()
            }
            display.text = String(format:"%.5f", pi)
            enter()

        }
        else if sender.currentTitle! == "." {
            if display.text!.rangeOfString(".") == nil {
            display.text = display.text! + "."
            }
        
        }
        else if userIsInTheMiddleOfTypingANumber {
           display.text = display.text! + digit
        }
        else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                displayValue = 0
            
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!){
            println("pressed enter")
            displayValue = result
        }
        else {
            displayValue = 0
        }
        history.text = brain.description
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false;
        }
    }
}

