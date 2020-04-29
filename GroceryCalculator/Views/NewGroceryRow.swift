//
//  NewGroceryRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 27/04/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct NewGroceryRow: View {
    @State var newGrocery = ""
    @EnvironmentObject var groceryItems: GroceryItems
    
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(.blue)
            
            TextField("Add a grocery", text: $newGrocery, onCommit: addGrocery)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    func addGrocery() {
        let groceryItem = GroceryItem(name: newGrocery)
        groceryItem.save()
        newGrocery = ""
        self.groceryItems.append(groceryItem)
    }
}

struct NewItemRow_Previews: PreviewProvider {
    static var previews: some View {
         return Group {
            NewGroceryRow().environmentObject(GroceryItems.withSampleData)
         }
         .previewLayout(.fixed(width: 300, height: 70))
    }
}
