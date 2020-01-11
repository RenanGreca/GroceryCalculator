//
//  PurchaseRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct PurchaseRow: View {
    
    @Binding var groceryItem: GroceryItem
    
    var body: some View {
        HStack {
            Text(groceryItem.name)
            Text("×\(groceryItem.amount)")
            Spacer()
            Text("€\(groceryItem.readablePrice)")
        }.padding()
    }
}

struct PurchaseRow_Previews: PreviewProvider {
    static var previews: some View {
        let bananas = GroceryItem(name: "Bananas")
        let apples = GroceryItem(name: "Apples")
        
        return Group {
            PurchaseRow(groceryItem: .constant(bananas))
            PurchaseRow(groceryItem: .constant(apples))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
