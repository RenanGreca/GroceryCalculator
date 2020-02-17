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
//    @State var groceries = GroceryItem.fetcshAll()
    
    var body: some View {
        return ZStack {
            // NavigationView including the list of groceries
            NavigationView {
                List(GroceryItem.fetchAll()) { grocery in
                    ListRow(groceryItem: .constant(grocery)).onTapGesture {
                        self.selectedGrocery = grocery
                        self.buyItemPopUpVisible.toggle()
                    }
                }
                .navigationBarTitle(Text("Grocery List"))
                .navigationBarItems(trailing: Button(action: {
                    // Toggle the visibility of the pop-up
                    self.addItemPopUpVisible.toggle()
                }, label: {
                    Image(systemName: "plus")
                    .frame(width: 30, height: 30)
                }).accessibility(identifier: "AddItem"))
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
                    let groceryItem = GroceryItem(name: name)
                    groceryItem.save()
//                    self.groceries = GroceryItem.fetchAll()
                    self.addItemPopUpVisible.toggle()
                }, cancelAction: {
                    self.addItemPopUpVisible.toggle()
                })
            }
            
            if (buyItemPopUpVisible) {
                Color.black.opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.buyItemPopUpVisible.toggle()
                    }
                
                BuyItemPopUp(amountString: "\(self.selectedGrocery!.amount)",
                    unitPriceString: String(format: "%.2f", self.selectedGrocery!.unitPrice),
                okAction: { amount, unitPrice in
                    if var groceryItem = self.selectedGrocery?.duplicate() {
                        groceryItem.amount = amount
                        groceryItem.unitPrice = unitPrice
                        groceryItem.save()
                    }
                    self.selectedGrocery = nil
//                    self.grocesries = GroceryItem.fetchAll()
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
