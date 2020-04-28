//
//  ListRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    
    @Binding var groceryItem: GroceryItem
    
    var body: some View {
        HStack {
            if (groceryItem.amount > 0) {
                Button(action: {
//                    self.selectedGrocery = grocery
//                    self.buyItemPopUpVisible.toggle()
                }, label: {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(.blue)
                })
                
                TextField("", text: $groceryItem.name, onCommit: updateGrocery)
                    .foregroundColor(.gray)
//                Text("×\(groceryItem.amount)")
//                Spacer()
                Text("€\(groceryItem.readablePrice)")
            } else {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(.blue)
                })
                
                TextField("", text: $groceryItem.name, onCommit: updateGrocery)
            }
            Spacer()
        }.padding()
    }
    
    func updateGrocery() {
        groceryItem.save()
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            ListRow(groceryItem: .constant(groceries[0]))
            ListRow(groceryItem: .constant(groceries[5]))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
