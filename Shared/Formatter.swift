//
//  Formatter.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 01/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation

struct Formatter {
    

    var number: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.isLenient = true
        return formatter
    }

    var currency: NumberFormatter {
        let formatter = self.number
        formatter.numberStyle = .currency
        return formatter
    }

    static func arrayFrom(double: Double) -> [Int] {
        var double = double
        var result:[Int] = []
        
        for _ in 0..<3 {
            result.append(Int(double))
            double -= Double(Int(double))
            double *= 10
        }
        
        return result
    }
    
    static func doubleFrom(array: [Int]) -> Double {
        
        var result: Double = 0
        for i in 0..<array.count {
            result += Double(array[i])/pow(10.0, Double(i))
        }
        return result
    }

}
