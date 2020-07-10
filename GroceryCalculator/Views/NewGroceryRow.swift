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
    var position: Int
    
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
        if (newGrocery.count > 0) {
            let _ = Grocery.new(name: newGrocery, position: position)
            CoreDataHelper.saveContext()
            self.newGrocery = ""
        }
    }
}

// MARK: - Preview
struct NewItemRow_Previews: PreviewProvider {
    static var previews: some View {
         return Group {
            NewGroceryRow(position: 0)
         }
         .previewLayout(.fixed(width: 300, height: 70))
    }
}
