//
//  BuyItemPopUp.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct BuyItemPopUp: View {
    
    @ObservedObject var groceryItem: GroceryItem
    @State var amountString: String
    @State var unitPriceString: String
    var okAction: (_: Int, _: Double) -> Void
    var cancelAction: () -> Void
    
    var body: some View {
        return NavigationView {
            VStack {
                TextField("Amount", text: $amountString)
                    .frame(height: 30.0)
                    .border(Color.gray)
                    .keyboardType(.decimalPad)
                TextField("Unit Price", text: $unitPriceString, onCommit: {
                    self.okAction(self.amount, self.unitPrice)
                })
                    .frame(height: 30.0)
                    .border(Color.gray)
                    .keyboardType(.decimalPad)
//                HStack {
//                    .frame(width: 90, height: 30)
//                    .frame(width: 90, height: 30)
//                }
                Spacer()
            }
            .navigationBarTitle(groceryItem.name)
            .navigationBarItems(leading: Button(action: {
                self.cancelAction()
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
            }, trailing: Button(action: {
                self.okAction(self.amount, self.unitPrice)
            }) {
                Text("Done").fontWeight(.bold)
            })
//            .padding()
//            .frame(width: 200, height: 160)
//                .background(Color(UIColor.systemBackground))
//            .cornerRadius(5)
//            .shadow(radius: 10)
        }
    }
    
    var amount: Int {
        return Int(self.amountString) ?? 0
    }
    
    var unitPrice: Double {
        let unitPriceString = self.unitPriceString.replacingOccurrences(of: ",", with: ".")
        return Double(unitPriceString) ?? 0.0
    }
}

struct BuyItemPopUp_Previews: PreviewProvider {
    static var previews: some View {
        BuyItemPopUp(groceryItem: groceries[0], amountString: "\(groceries[0].amount)",
            unitPriceString: String(format: "%.2f", groceries[0].unitPrice),
        okAction: { amount, price in
            print("\(amount), \(price)")
        }, cancelAction: {
            print("nothing added")
        })
    }
}
