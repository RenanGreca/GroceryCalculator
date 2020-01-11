//
//  GroceryList.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct GroceryList: View {
    
    @State var addItemPopUpVisible = false
    @State var buyItemPopUpVisible = false
    @State var selectedGrocery: GroceryItem?
    
    var body: some View {
        return ZStack {
            // NavigationView including the list of groceries
            NavigationView {
                List(groceries) { grocery in
                    ListRow(groceryItem: grocery).onTapGesture {
                        self.selectedGrocery = grocery
                        self.buyItemPopUpVisible.toggle()
                    }
                }
                .navigationBarTitle(Text("Grocery List"))
                .navigationBarItems(trailing: Button(action: {
                    // Toggle the visibility of the pop-up
                    self.addItemPopUpVisible.toggle()
                }) {
                    Image(systemName: "plus")
                    .frame(width: 30, height: 30)
                })
            }
            
            if (addItemPopUpVisible) {
                // If the pop-up should be visible, add a dark background
                Color.black.opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.addItemPopUpVisible.toggle()
                    }
                
                AddItemPopUp(
                okAction: { name in
                    groceries.append(GroceryItem(name: name))
                    self.addItemPopUpVisible.toggle()
                }, cancelAction: {
                    self.addItemPopUpVisible.toggle()
                })
            }
            
            if (buyItemPopUpVisible) {
                Color.black.opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.addItemPopUpVisible.toggle()
                    }
                
                BuyItemPopUp(amountString: "\(self.selectedGrocery!.amount)",
                    unitPriceString: String(format: "%.2f", self.selectedGrocery!.unitPrice),
                okAction: { amount, unitPrice in
//                    groceries.first(where: { $0.id == selectedGrocery?.id})?.amount = amount
//                    groceries.first(where: { $0.id == selectedGrocery?.id})?.unitPrice = unitPrice
                    self.selectedGrocery?.amount = amount
                    self.selectedGrocery?.unitPrice = unitPrice
                    self.buyItemPopUpVisible.toggle()
                }, cancelAction: {
                    self.buyItemPopUpVisible.toggle()
                })
            }
        }
    }
}

struct GroceryList_Previews: PreviewProvider {
    static var previews: some View {
        GroceryList()
    }
}
