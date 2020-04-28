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

struct CoreDataHelper {
    static var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

class GroceryItem: Identifiable, ObservableObject {
//    static func == (lhs: GroceryItem, rhs: GroceryItem) -> Bool {
//        return lhs.name == rhs.name
//    }
    
    internal var id: UUID
    @Published var name: String
    @Published var amount: Int
    @Published var unitPrice: Double
    
    init(name: String) {
        self.name = name
        self.amount = 0
        self.unitPrice = 0.0
        self.id = .init()
    }
    
    init(from managedItem:GroceryItemManagedObject) {
        self.id = managedItem.id!
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
            item = NSEntityDescription.insertNewObject(forEntityName: "GroceryItem", into: CoreDataHelper.context) as! GroceryItemManagedObject
        }
        item.id = self.id
        item.name = self.name
        item.unitPrice = self.unitPrice
        item.amount = Int64(self.amount)
        
        try? CoreDataHelper.context.save()
    }
    
    func duplicate() -> GroceryItem {
        let groceryItem = GroceryItem(name: self.name)
        groceryItem.id = self.id
        groceryItem.amount = self.amount
        groceryItem.unitPrice = self.unitPrice
        return groceryItem
    }
    
    static func fetchManagedWith(id:UUID) -> GroceryItemManagedObject? {
        let fetchRequest = NSFetchRequest<GroceryItemManagedObject>(entityName: "GroceryItem")
        let searchFilter = NSPredicate(format: "id = %@", id as CVarArg)
        fetchRequest.predicate = searchFilter
        
        let results = try? CoreDataHelper.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [GroceryItemManagedObject]
        
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
        
        if let results = try? CoreDataHelper.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [GroceryItemManagedObject] {
            for result in results {
                let item = GroceryItem(from: result)
                groceries.append(item)
            }
        }
        
        return groceries
    }
}
