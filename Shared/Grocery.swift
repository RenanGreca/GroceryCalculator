//
//  GroceryItem.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import CoreData
//import UIKit
import CloudKit

@objc(Grocery)
public class Grocery: NSManagedObject {
    var unitPriceString: String = ""
    
    static func new(name: String, position: Int = Int.max) -> Grocery {
        let item:Grocery
        if  let managedItem = Grocery.fetchManagedWith(name: name) {
            item = managedItem
        } else {
            item = NSEntityDescription.insertNewObject(forEntityName: Grocery.entityName, into: CoreDataHelper.context) as! Grocery
            item.name = name
            item.ckid = .init()
            item.uuid = .init()
        }
        
        item.desiredAmount = 1
        item.purchasedAmount = 0
        item.position = Int64(position)
        item.visible = true
        
        return item
    }
    
    private static func fetchManagedWith(name:String) -> Grocery? {
        let fetchRequest = NSFetchRequest<Grocery>(entityName: Grocery.entityName)
        let searchFilter = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = searchFilter
        
        let results = try? CoreDataHelper.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [Grocery]
        
        if let managedItem = results?.first {
            return managedItem
        } else {
            return nil
        }
    }
    
    func updatePosition(index: Int) {
        self.position = Int64(index)
    }
}

// MARK: - CoreData stored properties
extension Grocery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: Grocery.entityName)
    }

    @NSManaged public var desiredAmount: Int64
    @NSManaged public var uuid: UUID?
    @NSManaged public var name: String
    @NSManaged public var purchasedAmount: Int64
    @NSManaged public var unitPrice: Double
    @NSManaged public var ckid: String?
    @NSManaged public var position: Int64
    @NSManaged public var visible: Bool
    
    static var entityName: String { return "Grocery" }
}

// MARK: - Helpers for price visualization
extension Grocery {
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
            return (self.unitPriceString == "" && self.unitPrice > 0
                        ? Formatter().currency.string(for: self.unitPrice)!
                        : self.unitPriceString)
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
