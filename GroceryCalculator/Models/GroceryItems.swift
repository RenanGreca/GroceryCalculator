//
//  GroceryItems.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 24/04/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation

class GroceryItems: ObservableObject {
    @Published var list:[GroceryItem]
    
    init() {
        self.list = GroceryItem.fetchAll()
    }
    
    func refresh() {
        self.list = GroceryItem.fetchAll()
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

    func move(from source: IndexSet, to destination: Int) {
        list.move(fromOffsets: source, toOffset: destination)
    }
    
    func edit(groceryItem: GroceryItem) {
//        if let index = list.firstIndex(of: groceryItem) {
//            list.remove(at: index)
//            list.insert(groceryItem, at: index)
//            groceryItem.save()
//        }
        groceryItem.save()
        self.refresh()
    }
    
    func add(name: String) {
        let groceryItem = GroceryItem(name: name)
        groceryItem.save()
        list.append(groceryItem)
    }
    
    var total: Double {
        list.reduce(0) { $0 + $1.price }
    }
    
    var readablePrice: String {
        String(format: "%.2f", total)
    }
    
    class var withSampleData:GroceryItems {
        let groceryItems = GroceryItems()
        groceryItems.list = groceries
        return groceryItems
    }
}
