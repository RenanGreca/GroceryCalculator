//
//  GroceryItem.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import CoreData
import UIKit
import CloudKit

fileprivate var globalID = 1

//var groceries:[GroceryItem] = [GroceryItem(name: "Bananas"),
//                               GroceryItem(name: "Apples")]

var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.isLenient = true
    return formatter
}

var currencyFormatter: NumberFormatter {
    let formatter = numberFormatter
    formatter.numberStyle = .currency
    return formatter
}

class GroceryItem: Equatable, Identifiable, ObservableObject {
    static func == (lhs: GroceryItem, rhs: GroceryItem) -> Bool {
        return lhs.name == rhs.name
    }
    
    internal var uuid: UUID
    
    internal var id: CKRecord.ID
    var record: CKRecord?
//    let database: CKDatabase
    
    @Published var name: String
    @Published var desiredAmount: Int = 1
    @Published var purchasedAmount: Int = 0
    
    @Published var unitPrice: Double = 0.0
    private var unitPriceString: String = ""
    
    
    init(name: String) {
        self.name = name
//        self.amount = 0
//        self.unitPrice = 0.0
        self.id = .init()
        self.uuid = .init()
    }
    
    init(from managedItem:GroceryItemMO) {
        self.uuid = managedItem.id!
        self.id = CKRecord.ID(recordName: managedItem.ckid!)
        self.desiredAmount = Int(managedItem.desiredAmount)
        self.purchasedAmount = Int(managedItem.purchasedAmount)
        self.unitPrice = managedItem.unitPrice
        self.unitPriceString = numberFormatter.string(for: managedItem.unitPrice) ?? ""
        self.name = managedItem.name!
    }
    
    init?(from record:CKRecord, database: CKDatabase) {
        guard
            let name = record["name"] as? String,
            let desiredAmount = record["desiredAmount"] as? Int,
            let purchasedAmount = record["purchasedAmount"] as? Int,
            let unitPrice = record["unitPrice"] as? Double,
            let uuid = record["UUID"] as? String else {
                return nil
        }
        
        self.name = name
        self.desiredAmount = desiredAmount
        self.purchasedAmount = purchasedAmount
        self.unitPrice = unitPrice
        self.unitPriceString = (unitPrice == 0 ? "" : currencyFormatter.string(for: unitPrice) ?? "")
        
        self.id = record.recordID
        self.uuid = UUID(uuidString: uuid) ?? UUID()
        self.record = record
//        self.database = database
    }
    
//    var amountString: String {
//        get {
//            return "\(purchasedAmount)"
//        }
//        set {
//            self.purchasedAmount = Int(newValue) ?? 0
//        }
//    }
    
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
            if let unitPrice = numberFormatter.number(from: newValue) as? Double {
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
                    self.unitPriceString = numberFormatter.string(for: unitPrice) ?? newValue
                }
            }
        }
    }
    
    /// The total price of the units pruchased.
    var price: Double {
        unitPrice*Double(purchasedAmount)
    }
    
    /// The `price` formatted to the local currency.
    var readablePrice: String {
        return currencyFormatter.string(for: price) ?? ""
    }
    
    /// Saves the item to iCloud.
    func saveToCloud(completion: @escaping () -> Void) {
        let privateDB = CKContainer.default().privateCloudDatabase

        let record = self.record ?? CKRecord(recordType: "GroceryItem", recordID: self.id)
        
        record["name"] = self.name as NSString
        record["desiredAmount"] = self.desiredAmount as NSInteger
        record["purchasedAmount"] = self.purchasedAmount as NSInteger
        record["unitPrice"] = self.unitPrice as NSNumber
        record["UUID"] = self.uuid.uuidString
        
        privateDB.save(record) {
            (record, error) in
            if let _ = error {
                print("Error saving data to iCloud")
                return
            }
            print("Successfully saved data to iCloud")
            completion()
        }
    }
    
    func saveToCoreData() {
       let item:GroceryItemMO
       if let managedItem = GroceryItem.fetchManagedWith(id: self.uuid) {
           item = managedItem
       } else {
           item = NSEntityDescription.insertNewObject(forEntityName: "GroceryItem", into: CoreDataHelper.context) as! GroceryItemMO
       }
       item.ckid = self.id.recordName
       item.id = self.uuid
       item.name = self.name
       item.unitPrice = self.unitPrice
       item.desiredAmount = Int64(self.desiredAmount)
       item.purchasedAmount = Int64(self.purchasedAmount)

       try? CoreDataHelper.context.save()
    }
    
//    func duplicate() -> GroceryItem {
//        let groceryItem = GroceryItem(name: self.name)
//        groceryItem.id = self.id
//        groceryItem.purchasedAmount = self.purchasedAmount
//        groceryItem.desiredAmount = self.desiredAmount
//        groceryItem.unitPrice = self.unitPrice
//        return groceryItem
//    }
    
    /// Removes the item from CoreData.
    func delete() {
        let privateDB = CKContainer.default().privateCloudDatabase

        let record = self.record ?? CKRecord(recordType: "GroceryItem", recordID: self.id)
        
        privateDB.delete(withRecordID: record.recordID) {
            (recordID: CKRecord.ID?, error: Error?) -> Void in
            if let _ = error {
                print("Error saving data to iCloud")
                return
            }
            print("Successfully saved data to iCloud")
        }
        if let managedItem = GroceryItem.fetchManagedWith(id: self.uuid) {
            CoreDataHelper.context.delete(managedItem)
        }
    }
    
    /// Finds the item with the given `id`.
    static func fetchManagedWith(id:UUID) -> GroceryItemMO? {
        let fetchRequest = NSFetchRequest<GroceryItemMO>(entityName: "GroceryItem")
        let searchFilter = NSPredicate(format: "id = %@", id as CVarArg)
        fetchRequest.predicate = searchFilter

        let results = try? CoreDataHelper.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [GroceryItemMO]

        if let managedItem = results?.first {
            return managedItem
        } else {
            return nil
        }
    }
    
    /// Lists all items stored in CoreData.
    static func fetchAll() -> [GroceryItem] {
        let fetchRequest = NSFetchRequest<GroceryItemMO>(entityName: "GroceryItem")

        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        var groceries = [GroceryItem]()

        if let results = try? CoreDataHelper.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [GroceryItemMO] {
            for result in results {
                let item = GroceryItem(from: result)
                groceries.append(item)
            }
        }

        return groceries
    }
}

@objc(GroceryItemMO)
public class GroceryItemMO: NSManagedObject {

}


extension GroceryItemMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroceryItemMO> {
        return NSFetchRequest<GroceryItemMO>(entityName: "GroceryItem")
    }

    @NSManaged public var desiredAmount: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var purchasedAmount: Int64
    @NSManaged public var unitPrice: Double
    @NSManaged public var ckid: String?

}
