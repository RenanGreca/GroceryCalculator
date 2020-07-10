//
//  WatchRow.swift
//  Shopping Extension
//
//  Created by Renan Greca on 09/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct WatchGroceryRow: View {
    @ObservedObject var grocery: Grocery
    
    var body: some View {
        HStack {
            if (grocery.purchasedAmount > 0) {
                PurchasedRow(grocery: grocery)
            } else {
                UnpurchasedRow(grocery: grocery)
            }
        }
    }
}

extension WatchGroceryRow {
    
    struct PurchasedRow: View {
        @ObservedObject var grocery: Grocery

        var body: some View {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                                
                Text(grocery.name)
                    .foregroundColor(.gray)
                    .frame(height: 25)
                    .font(.system(.body, design: .rounded))

                Spacer()
                Text("\(grocery.readablePrice)")
                    .font(.system(.footnote, design: .rounded))

            }
        }
    }
    
    struct UnpurchasedRow: View {
        @ObservedObject var grocery: Grocery
        
        var body: some View {
            
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(.blue)

                Text(self.grocery.name)
                    .frame(height: 25)
                    .font(.system(.body, design: .rounded))
                
                Spacer()

            }
        }
    }
}

struct WatchRows_Previews: PreviewProvider {
    static var previews: some View {
        let grocery1 = Grocery.new(name: "Milk")
        grocery1.purchasedAmount = 2
        grocery1.unitPrice = 0.99
        
        let grocery2 = Grocery.new(name: "Butter")
        grocery2.purchasedAmount = 2
        grocery2.unitPrice = 1.49

        return Group {
            WatchGroceryRow(grocery:grocery1)
            
            WatchGroceryRow(grocery:grocery2)
        }
    }
}
