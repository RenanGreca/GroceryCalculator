//
//  BuyItemWatch.swift
//  Shopping Extension
//
//  Created by Renan Greca on 09/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import Combine

fileprivate let topPadding:CGFloat = -16.5
fileprivate let radius:CGFloat = 6
fileprivate let darkGray:Color = Color(red: 0.14,
                                       green: 0.14,
                                       blue: 0.14)

struct WatchGroceryDetail: View {
    @ObservedObject var grocery: Grocery
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                AmountStepper(grocery: self.grocery,
                              selectedNumber: Int(self.grocery.purchasedAmount),
                              pickerWidth: geometry.size.width/4,
                              pickerHeight: geometry.size.width/3)
                    .background(darkGray)
                    .cornerRadius(10)
                    .padding(.bottom, -5)
                    .padding(.top, 5)
                
                UnitPriceField(grocery: self.grocery,
                               selectedNumber: self.doubleToArray(double: self.grocery.unitPrice),
                               pickerWidth: geometry.size.width/4,
                               pickerHeight: geometry.size.width/3)
                    .background(darkGray)
                    .cornerRadius(10)
                    .padding(.bottom, -5)
                
                TotalPrice(totalPrice: self.grocery.readablePrice)
                    .background(darkGray)
                    .cornerRadius(10)
                    .frame(height: 30)
            }
            .navigationBarTitle("\(self.grocery.name)")
        }
    }
    
    func doubleToArray(double: Double) -> [Int] {
        var double = double
        var result:[Int] = []
        result.append(Int(double))
        double -= Double(Int(double))
        double *= 10
        result.append(Int(double))
        double -= Double(Int(double))
        double *= 10
        result.append(Int(double))
        
        return result
    }
    
}

struct BuyItemWatch_Previews: PreviewProvider {
    static var previews: some View {
        let grocery = Grocery.new(name: "Milk")
        grocery.purchasedAmount = 2
        grocery.unitPrice = 0.99
        
        return Group {
            WatchGroceryDetail(grocery: grocery)
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            WatchGroceryDetail(grocery: grocery)
                .previewDevice("Apple Watch Series 3 - 38mm")
                .environment(\.locale, Locale(identifier: "pt-br"))
        }

    }
}

struct AmountStepper: View {
    @ObservedObject var grocery: Grocery
    @State var selectedNumber: Int
    
    let pickerWidth:CGFloat
    let pickerHeight:CGFloat
    
    var body: some View {
        return HStack {
            VStack(alignment: .leading) {
                Text("Amount")
                    .font(.system(.footnote, design: .rounded))
                Spacer()
            }
            
            Spacer()

            Picker("", selection: $selectedNumber.onChange(updateGrocery), content: {
                ForEach(0..<100, id: \.self) { number in
                    Text("\(number)")
                        .font(.system(.title, design: .rounded))
                }
                .frame(width: pickerWidth+20, height: pickerHeight-10, alignment: .center)
            })
            
//                .pickerStyle(WheelPickerStyle())
            .frame(width: pickerWidth+20, height: pickerHeight, alignment: .center)
            .padding(.top, topPadding)
//                .clipShape(RoundedRectangle(cornerRadius: 6))
//                .background(Color.black)
            .cornerRadius(radius)
            
        }
        .frame(height: pickerHeight)
        .padding(.leading, 5)
        .padding(.trailing)
        
    }
    
    func updateGrocery(_ newValue: Int) {
        self.grocery.updatePurchasedAmount(newValue)
        CoreDataHelper.saveContext()
    }

}

struct UnitPriceField: View {
    @ObservedObject var grocery: Grocery
    @State var selectedNumber: [Int]
    
    let pickerWidth:CGFloat
    let pickerHeight:CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Unit Price")
                    .font(.system(.footnote, design: .rounded))
                Spacer()
            }
            
            HStack {
                Spacer(minLength: 0)
                
                Picker("", selection: $selectedNumber[0].onChange(updateGrocery), content: {
                    ForEach(0..<100, id: \.self) { number in
                        Text("\(number)")
                            .font(.system(.title, design: .rounded))
                    }
                })
                .frame(width: pickerWidth+20, height: pickerHeight, alignment: .center)
                .padding(.top, topPadding)
                .cornerRadius(radius)
                .padding(.trailing, -15)
                
                
                Text(Locale.current.decimalSeparator ?? ".")
                    .font(.title)
                    .padding(.horizontal, -5)
                
                Picker("", selection: $selectedNumber[1].onChange(updateGrocery), content: {
                    ForEach(0..<10, id: \.self) { number in
                        Text("\(number)")
                            .font(.system(.title, design: .rounded))
                    }
                })
                .frame(width: pickerWidth, height: pickerHeight, alignment: .center)
                .padding(.top, topPadding)
                .cornerRadius(radius)
                    .padding(.trailing, -7)
                
                Picker("", selection: $selectedNumber[2].onChange(updateGrocery), content: {
                    ForEach(0..<10, id: \.self) { number in
                        Text("\(number)")
                            .font(.system(.title, design: .rounded))
                    }
                })
                .frame(width: pickerWidth, height: pickerHeight, alignment: .center)
                .padding(.top, topPadding)
                .cornerRadius(radius)
            }
            
        }
        .padding(.leading, 5)
        .padding(.trailing)
//        .padding(.bottom, 30)
    }
    
    func updateGrocery(_ newValue: Int) {
        let num1:Double = Double(selectedNumber[0])
        let num2:Double = Double(selectedNumber[1])/10
        let num3:Double = Double(selectedNumber[2])/100
        
        self.grocery.unitPrice = num1+num2+num3
        CoreDataHelper.saveContext()
    }
}

struct TotalPrice: View {
    var totalPrice: String
    
    var body: some View {
        HStack {
            VStack {
                Text("Total")
                    .font(.system(.footnote, design: .rounded))
                
                Spacer()
            }
            .frame(width: 50, alignment: .leading)
            
            Spacer()
            Text("\(totalPrice)")
                .bold()
                .font(.system(size: 15, design: .rounded))
                .frame(height: 20)
            
        }
        .padding(.leading, 5)
        .padding(.trailing)
    }
}


extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
