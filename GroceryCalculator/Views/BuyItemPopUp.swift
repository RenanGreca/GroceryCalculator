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
    @State var price: Double = 0
    var okAction: (_: GroceryItem) -> Void
    var cancelAction: () -> Void
    
    var currencyFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.isLenient = true
        nf.currencySymbol = "€"
        return nf
    }
    
    var body: some View {
        return NavigationView {
            VStack {
                HStack {
                    Text("Amount:").font(.headline).fontWeight(.bold)
                    Spacer()
                    Stepper("\(groceryItem.amount)", value: $groceryItem.amount)
//                    TextField("Amount", text: $groceryItem.amountString)
//                        .frame(width: 100, height: 50)
//                        .border(Color.gray)
//                        .keyboardType(.decimalPad)
//                        .multilineTextAlignment(.trailing)
                    
//                        .font(.custom("SF", size: 24))
                }
                .padding()
                
                HStack {
                    Text("Unit Price").font(.headline).fontWeight(.bold)
                    Spacer()
//                    DecimalField("Unit Price", value: $groceryItem.unitPrice, formatter: self.currencyFormatter)
                    TextField("Unit Price", text: $groceryItem.unitPriceString, onCommit: {
                        self.okAction(self.groceryItem)
                    })
                        .frame(width: 100, height: 50)
                        .border(Color.gray)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                .padding()

                TotalRow(totalPrice: self.groceryItem.readablePrice)
                Spacer()
            }
            .padding(.horizontal, 30)
            .navigationBarTitle("\(groceryItem.name)", displayMode: .inline)
//            .navigationBarTitle(groceryItem.name, displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.cancelAction()
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
            }, trailing: Button(action: {
                self.okAction(self.groceryItem)
            }) {
                Text("Done").fontWeight(.bold)
            })
        }
    }
    
//    var amount: Int {
//        return Int(self.amountString) ?? 0
//    }
//
//    var unitPrice: Double {
//        let unitPriceString = self.unitPriceString.replacingOccurrences(of: ",", with: ".")
//        return Double(unitPriceString) ?? 0.0
//    }
}

struct BuyItemPopUp_Previews: PreviewProvider {
    static var previews: some View {
        let groceryItem = GroceryItem(name: "Milk")
        groceryItem.amount = 2
        groceryItem.unitPrice = 0.99
        
        return BuyItemPopUp(groceryItem: groceryItem,
        okAction: { groceryItem in
            print("\(groceryItem.amountString), \(groceryItem.readablePrice)")
        }, cancelAction: {
            print("nothing added")
        }).environment(\.colorScheme, .dark)
    }
}
