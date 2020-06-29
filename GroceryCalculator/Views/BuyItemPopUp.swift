//
//  BuyItemPopUp.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import UIKit

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
//                Spacer()
                AmountStepper(groceryItem: groceryItem)
                UnitPriceField(groceryItem: groceryItem, okAction: okAction)
                TotalPrice(totalPrice: self.groceryItem.readablePrice)
                Spacer()
            }
//            .frame(height: 300)
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
        .navigationViewStyle(StackNavigationViewStyle())
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
        groceryItem.purchasedAmount = 2
        groceryItem.unitPrice = 0.99
        
        return Group {
            BuyItemPopUp(groceryItem: groceryItem,
                         okAction: { groceryItem in
                            print("\(groceryItem.purchasedAmount), \(groceryItem.readablePrice)")
            }, cancelAction: {
                print("nothing added")
            })
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
                .previewDisplayName("iPhone SE")
            
            BuyItemPopUp(groceryItem: groceryItem,
                         okAction: { groceryItem in
                            print("\(groceryItem.purchasedAmount), \(groceryItem.readablePrice)")
            }, cancelAction: {
                print("nothing added")
            }).environment(\.colorScheme, .dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
}

struct AmountStepper: View {
    @ObservedObject var groceryItem: GroceryItem
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if self.groceryItem.purchasedAmount > 0 {
                        self.groceryItem.purchasedAmount -= 1
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.primary)
                })
                .frame(width: 50, height: 50)
                
                Spacer()
                
                VStack {
                    Text("\(groceryItem.purchasedAmount)")
                        .font(.largeTitle)
                }
                
                Spacer()
                
                Button(action: {
                    self.groceryItem.purchasedAmount += 1
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.primary)
                })
                .frame(width: 50, height: 50)
            }
            .padding(.horizontal)
            Text("Amount").font(.footnote)
        }
        .padding(.vertical, 50)
    }
}

struct UnitPriceField: View {
    @ObservedObject var groceryItem: GroceryItem
    var okAction: (_: GroceryItem) -> Void
    
    var body: some View {
        VStack {
            HStack {
                PriceField(currencyFormatter.string(for: 0.00)!, text: $groceryItem.visibleUnitPrice, isFirstResponder: true) {
                    self.okAction(self.groceryItem)
                }
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .frame(height: 50)
            }
            .padding(.horizontal)
            Text("Unit Price").font(.footnote)
        }
        .padding(.bottom, 50)
    }
}

struct TotalPrice: View {
    var totalPrice: String
    
    var body: some View {
        TotalRow(totalPrice: totalPrice)
//        VStack {
//            Text("\(totalPrice)")
//                .font(.footnote)
//                .frame(height: 50)
//            Text("Total")
//                .font(.footnote)
//        }
    }
}

struct PriceField: UIViewRepresentable {
    private var placeholder : String
    private var text : Binding<String>
    private var onCommit: () -> Void
    private var isFirstResponder: Bool = false

    init(_ placeholder:String, text:Binding<String>, isFirstResponder:Bool, onCommit: @escaping () -> Void) {
        self.placeholder = placeholder
        self.text = text
        self.onCommit = onCommit
        self.isFirstResponder = isFirstResponder
    }

    func makeCoordinator() -> PriceField.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<PriceField>) -> UITextField {

        let innertTextField = UITextField(frame: .zero)
        innertTextField.placeholder = placeholder
        innertTextField.text = text.wrappedValue
        innertTextField.delegate = context.coordinator
        innertTextField.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        innertTextField.textAlignment = .center
        innertTextField.keyboardType = .numberPad
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: innertTextField.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(innertTextField.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        innertTextField.inputAccessoryView = toolBar

        context.coordinator.setup(innertTextField)

        return innertTextField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PriceField>) {
        uiView.text = self.text.wrappedValue
        
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
//            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PriceField
        var didBecomeFirstResponder = false

        init(_ textFieldContainer: PriceField) {
            self.parent = textFieldContainer
        }

        func setup(_ textField:UITextField) {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text.wrappedValue = textField.text ?? ""

            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.parent.onCommit()
            return true
        }
        
        @objc func textFieldDidBeginEditing(_ textField: UITextField) {
            let numberValue = currencyFormatter.number(from: textField.text ?? "")
            let stringValue = numberFormatter.string(for: numberValue ?? 0)!
            
            self.parent.text.wrappedValue = stringValue
        }
        
        @objc func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            
            let numberValue = numberFormatter.number(from: textField.text ?? "")
            let stringValue = currencyFormatter.string(for: numberValue ?? 0)!
            
            self.parent.text.wrappedValue = stringValue
//            textField.text = stringValue
        }
        
    }
    
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
//        self.delegate?.textFieldDidEndEditing?(self, reason: .committed)
        self.resignFirstResponder()
    }
}
