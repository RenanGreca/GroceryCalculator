//
//  GroceryItems.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 24/04/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation
import CloudKit
import UserNotifications

class GroceryItems: ObservableObject {
    @Published var list:[GroceryItem] = []
    
//    init() {
//        self.refresh()
//    }
    
    func refresh(_ completion: ((Error?) -> Void)? = nil) {
//        self.list = GroceryItem.fetchAll()
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "GroceryItem", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        groceryItems(forQuery: query, completion)
    }
    
    private func groceryItems(forQuery query: CKQuery, _ completion: ((Error?) -> Void)?) {
        let privateDB = CKContainer.default().privateCloudDatabase
        
        privateDB
            .perform(query,
                     inZoneWith: CKRecordZone.default().zoneID) {
                        [weak self] results, error in
                        
                        guard let self = self else { return }
                        if let error = error {
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                completion?(error)
                            }
                            return
                        }
                        
                        guard let results = results else { return }
                        
                        DispatchQueue.main.async {
                            self.list = results.compactMap() {
                                GroceryItem(from: $0, database: privateDB)
                            }
                            completion?(nil)
                        }
            
        }
        
    }
    
    func append(_ groceryItem: GroceryItem) {
        self.list.append(groceryItem)
    }
    
    func remove(at offsets: IndexSet) {
        for index in offsets {
            let groceryItem = list[index]
            groceryItem.delete()
        }
        list.remove(atOffsets: offsets)
    }
    
    func clear() {
        for groceryItem in list {
            groceryItem.delete()
        }
        self.refresh()
    }

    func move(from source: IndexSet, to destination: Int) {
        list.move(fromOffsets: source, toOffset: destination)
    }
    
    func edit(groceryItem: GroceryItem) {
//        if let index = list.firstIndex(of: groceryItem) {
//            list.remove(at: index)
//            list.insert(groceryItem, at: index)
//            groceryItem.save()
//        }
        groceryItem.save() {
            self.refresh()
        }
    }
    
    func add(name: String) {
        let groceryItem = GroceryItem(name: name)
        groceryItem.save() {
//            self.refresh()
            DispatchQueue.main.async {
                self.list.append(groceryItem)
            }
        }
    }
    
    var total: Double {
        list.reduce(0) { $0 + $1.price }
    }
    
    var readablePrice: String {
        currencyFormatter.string(for: total) ?? "0"
    }
    
    class var withSampleData:GroceryItems {
        let groceryItems = GroceryItems()
        groceryItems.list = groceries
        return groceryItems
    }
}
