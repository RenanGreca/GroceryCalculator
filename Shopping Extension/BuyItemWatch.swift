//
//  BuyItemWatch.swift
//  Shopping Extension
//
//  Created by Renan Greca on 09/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct BuyItemWatch: View {
    @ObservedObject var grocery: Grocery
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                AmountStepper(groceryItem: self.grocery)
                UnitPriceField(groceryItem: self.grocery,
                               okAction: { })
                TotalPrice(totalPrice: self.grocery.readablePrice)
            }
            .navigationBarTitle("\(self.grocery.name)")
        }
    }
    
}

struct BuyItemWatch_Previews: PreviewProvider {
    static var previews: some View {
        let grocery = Grocery.new(name: "Milk")
        grocery.purchasedAmount = 2
        grocery.unitPrice = 0.99
        
        return Group {
            BuyItemWatch(grocery: grocery)
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            BuyItemWatch(grocery: grocery)
                .previewDevice("Apple Watch Series 3 - 38mm")
        }

    }
}

struct AmountStepper: View {
    @ObservedObject var groceryItem: Grocery
    @State var selectedNumber: PossibleNumbers = .one
    
    let pickerWidth:CGFloat = 35
    let pickerHeight:CGFloat = 60
    
    var body: some View {

            HStack {
                VStack {
                    Text("Amount").font(.footnote)
                    Spacer()
                }
                
                Spacer()
                
                Picker("", selection: $selectedNumber, content: {
                    ForEach(PossibleNumbers.allCases, id: \.self) { number in
                        Text("\(number.rawValue)")
                            .font(.title)
                    }
                })
                .frame(width: pickerWidth+15, height: pickerHeight+15, alignment: .center)
                .padding(.top, -15)
                
            }
            .frame(height: pickerHeight)
            .padding(.horizontal)
            
//        .padding(.vertical, -15)
    }
}

struct UnitPriceField: View {
    @ObservedObject var groceryItem: Grocery
    var okAction: () -> Void
    
    @State var selectedNumber: [PossibleNumbers] = [.zero, .zero, .zero]
    
    let pickerWidth:CGFloat = 35
    let pickerHeight:CGFloat = 60
    
    var body: some View {
        VStack {
            HStack {
                Text("Unit Price").font(.footnote)
                Spacer()
            }
            
            HStack {
                
                Picker("Unit Price", selection: $selectedNumber[0], content: {
                    ForEach(PossibleNumbers.allCases, id: \.self) { number in
                        Text("\(number.rawValue)")
                            .font(.title)
                    }
                })
                .frame(width: pickerWidth, height: pickerHeight, alignment: .center)
                .padding(.top, -10)
                
                Text(".")
                    .font(.title)
                    .padding(.horizontal, -5)
                
                Picker("", selection: $selectedNumber[1], content: {
                    ForEach(PossibleNumbers.allCases, id: \.self) { number in
                        Text("\(number.rawValue)")
                            .font(.title)
                    }
                })
                .frame(width: pickerWidth, height: pickerHeight, alignment: .center)
                .padding(.top, -10)
                
                Picker("", selection: $selectedNumber[2], content: {
                    ForEach(PossibleNumbers.allCases, id: \.self) { number in
                        Text("\(number.rawValue)")
                            .font(.title)
                    }
                })
                .frame(width: pickerWidth, height: pickerHeight, alignment: .center)
                .padding(.top, -10)
//                Text(groceryItem.visibleUnitPrice)
//                    .font(.largeTitle)
//                    .frame(height: 30)
            }
//            .padding(.vertical, -15)
            
        }
//        .padding(.bottom, 30)
    }
}

struct TotalPrice: View {
    var totalPrice: String
    
    var body: some View {
        HStack {
            Text("Total: ")
                .font(.footnote)
                .frame(height: 20)
            
            Text("\(totalPrice)")
                .bold()
                .font(.footnote)
                .frame(height: 20)
            
            Spacer()
        }
    }
}

enum PossibleNumbers: Int, CaseIterable {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
}
