//
//  GroceryItem+CoreDataProperties.swift
//  Shopping Extension
//
//  Created by Renan Greca on 02/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//
//

import Foundation
import CoreData


extension GroceryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroceryItem> {
        return NSFetchRequest<GroceryItem>(entityName: "GroceryItem")
    }

    @NSManaged public var ckid: String?
    @NSManaged public var desiredAmount: Int64
    @NSManaged public var name: String?
    @NSManaged public var position: Int64
    @NSManaged public var purchasedAmount: Int64
    @NSManaged public var unitPrice: Double
    @NSManaged public var uuid: UUID?

}

// MARK: - Helpers for price visualization
extension GroceryItem {
    /// The total price of the units pruchased.
    var price: Double {
        unitPrice*Double(purchasedAmount)
    }
    
    /// The `price` formatted to the local currency.
    var readablePrice: String {
        return Formatter().currency.string(for: price) ?? ""
    }
    
    /// Used for binding with TextFields. Automatically sets the unitPrice.
    var visibleUnitPrice: String {
        get {
            // Just show the formatted string
            return self.unitPriceString
        }
        set {
            if  let symbol = Locale.current.currencySymbol,
                newValue.contains(symbol) {
                self.unitPriceString = newValue
                return
            }
            
            self.unitPriceString = newValue
            if let unitPrice = Formatter().number.number(from: newValue) as? Double {
                self.unitPrice = unitPrice
            }
            let numericCharacters = CharacterSet(charactersIn: "1234567890")
            // Remove all non-numeric characters from string
            var input = newValue.components(separatedBy: numericCharacters.inverted).joined()
        
            if (input.count == 0) {
                input = "000"
            } else if (input.count == 1) {
                input = "00\(input)"
            } else if (input.count == 2) {
                input = "0\(input)"
            }
            // Insert a . at the proper location
            input.insert(".", at: input.index(input.endIndex, offsetBy: -2))
            
            // Set the new unit price
            if let unitPrice = Double(input) {
                // Save the valid number
                self.unitPrice = unitPrice
                // Format the string for the input field
                if self.unitPrice == 0 {
                    self.unitPriceString = ""
                } else {
                    self.unitPriceString = Formatter().number.string(for: unitPrice) ?? newValue
                }
            }
        }
    }
}
