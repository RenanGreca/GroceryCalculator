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
    
    func onDelete(offsets: IndexSet) {
        list.remove(atOffsets: offsets)
    }

    func onMove(source: IndexSet, destination: Int) {
        list.move(fromOffsets: source, toOffset: destination)
    }
    
//    func edit(groceryItem: GroceryItem) {
//        var index = list.firstIndex(of: groceryItem)
//        list.remove(at: index)
//        list.insert(groceryItem, at: index)
//        
//        self.groceryItems.refresh()
//    }
    
    func add(name: String) {
        let groceryItem = GroceryItem(name: name)
        groceryItem.save()
        list.append(groceryItem)
    }
    
    var total: Double {
        list.reduce(0) { $0 + $1.price }
    }
    
    class var withSampleData:GroceryItems {
        let groceryItems = GroceryItems()
        groceryItems.list = groceries
        return groceryItems
    }
}
