//
//  PurchaseList.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct PurchaseList: View {
    
    @EnvironmentObject var groceryItems:GroceryItems
    
    var body: some View {
        NavigationView {
            VStack {
                List(groceryItems.list.filter({ $0.amount > 0 })) { grocery in
                    PurchaseRow(groceryItem: .constant(grocery))
                }
                TotalRow(totalPrice: groceryItems.readablePrice)
            }
            .navigationBarTitle(Text("Purchases"))
//            .navigationBarItems(trailing: Button(action: {
//                // Toggle the visibility of the pop-up
////                self.popUpVisible.toggle()
//            }) {
//                Image(systemName: "plus")
//                .frame(width: 30, height: 30)
//            })
            
        }
    }
}

struct PurchaseList_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseList()
    }
}
