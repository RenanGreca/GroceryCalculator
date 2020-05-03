//
//  ListRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    
    var showBuyItemPopUp:((GroceryItem) -> Void)
    @ObservedObject var groceryItem: GroceryItem
    @EnvironmentObject var groceryItems: GroceryItems
    @State var pushed = false
    
    var body: some View {
        HStack {
            if (groceryItem.purchasedAmount > 0) {
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
            } else {
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
            Spacer()
        }
        .padding(.vertical, 10)
        .sheet(isPresented: $pushed) {
                BuyItemPopUp(groceryItem: self.groceryItem,
                okAction: self.buyItem(groceryItem:),
                cancelAction: {self.pushed = false})
        }
    }
    
    func updateGrocery() {
        groceryItem.save()
        groceryItems.refresh()
    }
    
    func buyItem(groceryItem: GroceryItem) {
        groceryItem.save()
        self.groceryItems.refresh()
        self.pushed = false
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        let grocery1 = GroceryItem(name: "Milk")
        grocery1.purchasedAmount = 2
        grocery1.unitPrice = 0.99
        
        let grocery2 = GroceryItem(name: "Butter")
        grocery2.purchasedAmount = 0
        grocery2.unitPrice = 0.99
        
        return Group {
            ListRow(showBuyItemPopUp: {_ in }, groceryItem: grocery1)
            ListRow(showBuyItemPopUp: {_ in }, groceryItem: grocery2)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
