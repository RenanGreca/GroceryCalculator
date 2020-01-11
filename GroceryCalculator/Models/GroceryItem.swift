//
//  GroceryItem.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

fileprivate var globalID = 1

//var groceries:[GroceryItem] = [GroceryItem(name: "Bananas"),
//                               GroceryItem(name: "Apples")]

struct GroceryItem: Hashable, Codable, Identifiable {
    static func == (lhs: GroceryItem, rhs: GroceryItem) -> Bool {
        return lhs.name == rhs.name
    }
    
    var id: Int
    var name: String
    var amount: Int
    var unitPrice: Double
    
    init(name: String) {
        self.name = name
        self.amount = 2
        self.unitPrice = 0.99
        self.id = (groceries.last?.id ?? 0) + 1
    }
    
    var price: Double {
        unitPrice*Double(amount)
    }
    
    var readablePrice: String {
        String(format: "%.2f", price)
    }
}
