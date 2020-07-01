//
//  TotalRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct TotalRow: View {
    var totalPrice: String
    
//    @FetchRequest(entity: GroceryItemMO.entity(),
//                  sortDescriptors: [],
//                  predicate: NSPredicate(value: true),
//                  animation: .spring())
//    var fetchedGroceries: FetchedResults<GroceryItemMO>
    
    var body: some View {
//        let total = fetchedGroceries.reduce(0) { $0 + $1.price }
//        let totalPrice = currencyFormatter.string(for: total) ?? "0"
        
        return HStack {
            Text("Total").bold()
            Spacer()
            Text("\(totalPrice)").font(.title).bold()
        }
        .padding()
        .padding(.bottom, 10)
    }

}

struct TotalRow_Previews: PreviewProvider {
    static var previews: some View {
        TotalRow(totalPrice: "12.39 €")
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
