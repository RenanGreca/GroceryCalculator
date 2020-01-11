//
//  ListRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    
    var groceryItem: GroceryItem
    
    var body: some View {
        HStack {
            if (groceryItem.amount > 0) {
                Text(groceryItem.name)
                    .foregroundColor(.gray)
                    .strikethrough()
            } else {
                Text(groceryItem.name)
            }
            Spacer()
        }.padding()
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            ListRow(groceryItem: groceries[0])
            ListRow(groceryItem: groceries[5])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
