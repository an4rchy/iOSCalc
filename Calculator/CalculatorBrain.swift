//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Penemetsa, Arjun on 2/19/15.
//  Copyright (c) 2015 Arjun Penemetsa. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    var variableValues = [String: Double]()
    var description: String {
        get {
            var someString = ""
            var blah:Op
            var someStack = opStack
            while !someStack.isEmpty {
                blah = someStack.removeLast()
                switch blah {
                case .UnaryOperation(let symbol,_):
                    someString += symbol + "("
                case .Operand(let value):
                    someString += "\(value)"
                }
                case .BinaryOperation(let symbol, _):
                    someString+= symbol
            }
            return "\(opStack)"
            }
    }

    init() {
        knownOps["C"] = Op.UnaryOperation("C",{(test: Double) -> Double in return 0.0})
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)

    }
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation (symbol: String) -> Double? {
        
        if let operation = knownOps[symbol] {
            opStack.append(operation)

        }
        if symbol == "C" {
            opStack.removeAll(keepCapacity: false)
        }
        return evaluate()
    }
    private func evaluate (ops: [Op]) -> (result: Double?,remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                 return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)

                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), remainingOps)
                    }
                }

            }
            
        }
        return (nil, ops)
    
    }
    
    func evaluate () -> Double? {
        let (result, remainder)  = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
}


