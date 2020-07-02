//
//  ListRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    
    @ObservedObject var groceryItem: GroceryItem
    @State var pushed = false
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack {
            if (groceryItem.purchasedAmount > 0) {
                PurchasedRow()
            } else {
                UnpurchasedRow()
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .sheet(isPresented: $pushed) {
            BuyItemPopUp(groceryItem: self.groceryItem,
                         okAction: self.okAction,
                         cancelAction: self.cancelAction)
        }
    }
    
    func updateGrocery() {
        if (groceryItem.name.count == 0) {
            // If the string is empty, we can delete this item
            self.context.delete(self.groceryItem)
        } else {
            // Save the updated name
            CoreDataHelper.saveContext()
        }
    }
    
    func okAction() {
        CoreDataHelper.saveContext()
        self.pushed = false
    }
    
    func cancelAction() {
        self.groceryItem.purchasedAmount = 0
        CoreDataHelper.saveContext()
        self.pushed = false
    }
    
}

extension ListRow {
    
    private func PurchasedRow() -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
            .resizable()
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.groceryItem.purchasedAmount = 0
                    self.updateGrocery()
                }
                            
            TextField("", text: $groceryItem.name, onCommit: updateGrocery)
                .foregroundColor(.gray)
                .frame(height: 25)

            
            Text("\(groceryItem.readablePrice)")
                .onTapGesture {
                    self.groceryItem.purchasedAmount = self.groceryItem.desiredAmount
                    self.pushed = true
                }
        }
    }
    
    private func UnpurchasedRow() -> some View {
        HStack {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(.blue)
                .onTapGesture {
                    // Once we choose to buy a grocery, let's automatically say that we purchased the amount we wanted.
                    self.groceryItem.purchasedAmount = self.groceryItem.desiredAmount
                    self.pushed = true
                }
            
            TextField("", text: $groceryItem.name, onCommit: updateGrocery)
                .frame(height: 25)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        let grocery1 = GroceryItem.new(name: "Milk")
        grocery1.purchasedAmount = 2
        grocery1.unitPrice = 0.99
        
        let grocery2 = GroceryItem.new(name: "Butter")
        grocery2.purchasedAmount = 0
        grocery2.unitPrice = 0.99
        
        return Group {
            ListRow(groceryItem: grocery1)
                .environment(\.colorScheme, .dark)
            ListRow(groceryItem: grocery2)
        }
        .environment(\.managedObjectContext, CoreDataHelper.context)
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
