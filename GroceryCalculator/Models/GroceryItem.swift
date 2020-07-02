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

@objc(GroceryItem)
public class GroceryItem: NSManagedObject {
    private var unitPriceString: String = ""
    
    static func new(name: String, position: Int = Int.max) -> GroceryItem {
        let item = GroceryItem.fetch()
        
        item.name = name
        item.ckid = .init()
        item.uuid = .init()
        item.desiredAmount = 1
        item.purchasedAmount = 0
        item.position = Int64(position)
        
        return item
    }
    
    static func fetch(uuid: UUID? = nil) -> GroceryItem {
        let item:GroceryItem
        if  let uuid = uuid,
            let managedItem = GroceryItem.fetchManagedWith(id: uuid) {
            item = managedItem
        } else {
            item = NSEntityDescription.insertNewObject(forEntityName: GroceryItem.entityName, into: CoreDataHelper.context) as! GroceryItem
        }
        
        return item
    }
    
    static func fetchManagedWith(id:UUID) -> GroceryItem? {
        let fetchRequest = NSFetchRequest<GroceryItem>(entityName: GroceryItem.entityName)
        let searchFilter = NSPredicate(format: "uuid = %@", id as CVarArg)
        fetchRequest.predicate = searchFilter
        
        let results = try? CoreDataHelper.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [GroceryItem]
        
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
extension GroceryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroceryItem> {
        return NSFetchRequest<GroceryItem>(entityName: GroceryItem.entityName)
    }

    @NSManaged public var desiredAmount: Int64
    @NSManaged public var uuid: UUID?
    @NSManaged public var name: String
    @NSManaged public var purchasedAmount: Int64
    @NSManaged public var unitPrice: Double
    @NSManaged public var ckid: String?
    @NSManaged public var position: Int64
    
    static var entityName: String { return "GroceryItem" }
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
            // Cheating; only works for euros
            if newValue.contains("€") {
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
                    self.unitPriceString = Formatter().currency.string(for: unitPrice) ?? newValue
                }
            }
        }
    }
}
