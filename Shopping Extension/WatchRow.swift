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
//                    .onTapGesture {
//                        // Once we choose to buy a grocery, let's automatically say that we purchased the amount we wanted.
//                        self.grocery.purchasedAmount = self.grocery.desiredAmount
//                        //                    self.pushed = true
//                }
                
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
        let grocery = Grocery.new(name: "Milk")
        grocery.purchasedAmount = 2
        grocery.unitPrice = 0.99

        return Group {
            WatchGroceryRow.UnpurchasedRow(grocery:grocery)
            
            WatchGroceryRow.PurchasedRow(grocery:grocery)
        }
    }
}
