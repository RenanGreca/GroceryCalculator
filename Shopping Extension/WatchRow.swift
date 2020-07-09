//
//  WatchRow.swift
//  Shopping Extension
//
//  Created by Renan Greca on 09/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct WatchRow: View {
    @ObservedObject var grocery: Grocery
    @Environment(\.managedObjectContext) var context
    
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

extension WatchRow {
    
    struct PurchasedRow: View {
        @ObservedObject var grocery: Grocery
        @Environment(\.managedObjectContext) var context

        var body: some View {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        self.grocery.purchasedAmount = 0
                        try? self.context.save()
                    }
                                
                Text(grocery.name)
                    .foregroundColor(.gray)
                    .frame(height: 25)
                    .font(.system(.body, design: .rounded))

                Spacer()
                Text("\(grocery.readablePrice)")
                    .onTapGesture {
                        self.grocery.purchasedAmount = self.grocery.desiredAmount
                    }
            }
        }
    }
    
    struct UnpurchasedRow: View {
        @ObservedObject var grocery: Grocery
        @Environment(\.managedObjectContext) var context
        
        var body: some View {
            
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        // Once we choose to buy a grocery, let's automatically say that we purchased the amount we wanted.
                        self.grocery.purchasedAmount = self.grocery.desiredAmount
                        //                    self.pushed = true
                }
                
                Text(self.grocery.name)
                    .frame(height: 25)
                    .font(.system(.body, design: .rounded))
                
                Spacer()

            }
        }
    }
}
