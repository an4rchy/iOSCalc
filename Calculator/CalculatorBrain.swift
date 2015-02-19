//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Penemetsa, Arjun on 2/19/15.
//  Copyright (c) 2015 Arjun Penemetsa. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
    }
    private var opStack = [Op]()
    private var knownOps = [String: Op]()

    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
//        knownOps["√"] = Op.UnaryOperation("√") {sqrt($0)}

    }
    
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation (symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
    func evaluate (var ops: [Op]) -> (result: Double?,remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                let operand = operandEvaluation.result
                return (operation(operand), ...)
                
            }
            
        }
        return (nil, ops)
    
    }
    
    func evaluate () -> Double? {
        evaluate(opStack)
    }
    
}


