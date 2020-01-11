//
//  GroceryItem.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import CoreData
import UIKit

fileprivate var globalID = 1

//var groceries:[GroceryItem] = [GroceryItem(name: "Bananas"),
//                               GroceryItem(name: "Apples")]

let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        self.amount = 0
        self.unitPrice = 0.0
        self.id = GroceryItem.fetchAll().count
    }
    
    init(from managedItem:GroceryItemManagedObject) {
        self.id = Int(managedItem.id)
        self.amount = Int(managedItem.amount)
        self.unitPrice = managedItem.unitPrice
        self.name = managedItem.name!
    }
    
    var price: Double {
        unitPrice*Double(amount)
    }
    
    var readablePrice: String {
        String(format: "%.2f", price)
    }
    
    func save() {
        let item:GroceryItemManagedObject
        if let managedItem = GroceryItem.fetchManagedWith(id: self.id) {
            item = managedItem
        } else {
            item = NSEntityDescription.insertNewObject(forEntityName: "GroceryItem", into: context) as! GroceryItemManagedObject
        }
        item.id = Int64(self.id)
        item.name = self.name
        item.unitPrice = self.unitPrice
        item.amount = Int64(self.amount)
        
        try? context.save()
    }
    
    func duplicate() -> GroceryItem {
        var groceryItem = GroceryItem(name: self.name)
        groceryItem.id = self.id
        groceryItem.amount = self.amount
        groceryItem.unitPrice = self.unitPrice
        return groceryItem
    }
    
    static func fetchManagedWith(id:Int) -> GroceryItemManagedObject? {
        let fetchRequest = NSFetchRequest<GroceryItemManagedObject>(entityName: "GroceryItem")
        let searchFilter = NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = searchFilter
        
        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [GroceryItemManagedObject]
        
        if let managedItem = results?.first {
            return managedItem
        } else {
            return nil
        }
    }
    
    static func fetchAll() -> [GroceryItem] {
        let fetchRequest = NSFetchRequest<GroceryItemManagedObject>(entityName: "GroceryItem")
                
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var groceries = [GroceryItem]()
        
        if let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [GroceryItemManagedObject] {
            for result in results {
                let item = GroceryItem(from: result)
                groceries.append(item)
            }
        }
        
        return groceries
    }
}
