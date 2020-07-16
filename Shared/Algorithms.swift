//
//  Algorithms.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 16/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation
import SwiftUI

extension FetchedResults where Result == Grocery {
    
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        
        var list = self.compactMap { $0 }
        
        list.move(fromOffsets: source, toOffset: destination)
        
        for i in 0..<list.count {
            list[i].updatePosition(index: i)
        }
    }
    
}

extension Double {
    
    func toArray(maxLength: Int = 3) -> [Int] {
        
        var double = self
        var result:[Int] = []
        
        for _ in 0..<maxLength {
            result.append(Int(double))
            double -= Double(Int(double))
            double *= 10
        }
        
        return result
        
    }
    
}

extension Array where Element == Int {
    
    func toDouble() -> Double {
        
        var result = 0.0
        
        for i in 0..<count {
            result += Double(self[i])/pow(10.0, Double(i))
        }
        
        return result
        
    }
    
}
