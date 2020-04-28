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
            if (groceryItem.amount > 0) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.blue)
                    .onTapGesture {
//                        showBuyItemPopUp()
                        self.groceryItem.amount = 0
                        self.updateGrocery()
                    }
                                
                TextField("", text: $groceryItem.name, onCommit: updateGrocery)
                    .foregroundColor(.gray)
//                Text("×\(groceryItem.amount)")
//                Spacer()
                Text("€\(groceryItem.readablePrice)")
            } else {
//                NavigationLink(destination: BuyItemPopUp(amountString: "\(self.groceryItem.amount)",
//                                                         unitPriceString: String(format: "%.2f", self.groceryItem.unitPrice),
//                                                         okAction: buyItem(amount:unitPrice:),
//                                                         cancelAction: {self.pushed = false}), isActive: $pushed) {
//                    Image(systemName: "circle")
//                        .resizable()
//                        .frame(width: 25, height: 25, alignment: .center)
//                }
//                Navig
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        self.pushed = true
                        
//                        self.showBuyItemPopUp(self.groceryItem)
//                        self.groceryItem.amount = 1
//                        self.updateGrocery()
                    }
                
                TextField("", text: $groceryItem.name, onCommit: updateGrocery)
            }
            Spacer()
        }.padding()
        .sheet(isPresented: $pushed) {
                BuyItemPopUp(groceryItem: self.groceryItem,
                    amountString: "\(self.groceryItem.amount)",
                unitPriceString: String(format: "%.2f", self.groceryItem.unitPrice),
                okAction: self.buyItem(amount:unitPrice:),
                cancelAction: {self.pushed = false})
        }
    }
    
    func updateGrocery() {
        groceryItem.save()
        groceryItems.refresh()
//        groceryItems.edit(groceryItem: groceryItem)
    }
    
    func buyItem(amount: Int, unitPrice: Double) {
        groceryItem.amount = amount
        groceryItem.unitPrice = unitPrice
        groceryItem.save()
//        self.selectedGrocery = nil
        self.groceryItems.refresh()
        self.pushed = false
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            ListRow(showBuyItemPopUp: {_ in }, groceryItem: groceries[0])
            ListRow(showBuyItemPopUp: {_ in }, groceryItem: groceries[5])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
