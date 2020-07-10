//
//  ListRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct GroceryRow: View {
    
    @ObservedObject var grocery: Grocery
    @State var pushed = false
    @State var isEditing:Bool
        
    var body: some View {
        HStack {
            if (grocery.purchasedAmount > 0) {
                PurchasedRow(grocery: grocery,
                             pushed: $pushed,
                             isEditing: $isEditing)
            } else {
                UnpurchasedRow(grocery: grocery,
                               pushed: $pushed,
                               isEditing: $isEditing)
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .sheet(isPresented: $pushed) {
            GroceryDetail(groceryItem: self.grocery,
                         okAction: self.okAction,
                         cancelAction: self.cancelAction)
        }
        .contextMenu {
            // Rename button
            Button(action: {
                self.isEditing.toggle()
            }, label: {
                HStack {
                    Text("Rename")
                    Image(systemName: "square.and.pencil")
                }
            })
                            
            // Delete button
            Button(action: {
                self.grocery.visible = false
                CoreDataHelper.saveContext()
            }, label: {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            })
        }
    }
    
    func okAction() {
        CoreDataHelper.saveContext()
        self.pushed = false
    }
    
    func cancelAction() {
        self.grocery.purchasedAmount = 0
        CoreDataHelper.saveContext()
        self.pushed = false
    }
    
}

extension GroceryRow {
    
    struct PurchasedRow: View {
        @ObservedObject var grocery: Grocery
        @Binding var pushed: Bool
        @Binding var isEditing: Bool
        
        var body: some View {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.grocery.purchasedAmount = 0
                    CoreDataHelper.saveContext()
                }
                
                if (isEditing) {
                    TextField("", text: $grocery.name) {
                        self.isEditing.toggle()
                        if (self.grocery.name.count == 0) {
                            // If the string is empty,
                            // we can delete this item
                            CoreDataHelper.delete(self.grocery)
                        } else {
                            // Save the updated name
                            CoreDataHelper.saveContext()
                        }
                    }
                    .foregroundColor(.gray)
                    .frame(height: 25)
                    .foregroundColor(Color.primary)
                    .background(Color(UIColor.secondarySystemBackground))
                    .border(Color.gray, width: 1)
                    .cornerRadius(2)
                } else {
                    Text(grocery.name)
                    .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                Text("\(grocery.readablePrice)")
                .onTapGesture {
                    self.grocery.purchasedAmount = self.grocery.desiredAmount
                    self.pushed = true
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if !self.isEditing {
                    self.grocery.purchasedAmount = 0
                    CoreDataHelper.saveContext()
                }
            }
            
        }
    }
    
    struct UnpurchasedRow: View {
        @ObservedObject var grocery: Grocery
        @Binding var pushed: Bool
        @Binding var isEditing: Bool
        
        var body: some View {
            HStack {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        // Once we choose to buy a grocery, let's automatically say that we purchased the amount we wanted.
                        self.grocery.purchasedAmount = self.grocery.desiredAmount
                        self.pushed = true
                    }
                
                if (isEditing) {
                    TextField("", text: $grocery.name) {
                        self.isEditing.toggle()
                        if (self.grocery.name.count == 0) {
                            // If the string is empty,
                            // we can delete this item
                            CoreDataHelper.delete(self.grocery)
                        } else {
                            // Save the updated name
                            CoreDataHelper.saveContext()
                        }
                    }
                    .frame(height: 25)
                    .foregroundColor(Color.primary)
                    .background(Color(UIColor.secondarySystemBackground))
                    .border(Color.gray, width: 1)
                    .cornerRadius(2)

                } else {
                    Text(grocery.name)
                    Spacer()
                }
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if !self.isEditing {
                    // Once we choose to buy a grocery, let's automatically say that we purchased the amount we wanted.
                    self.grocery.purchasedAmount = self.grocery.desiredAmount
                    self.pushed = true
                }
            }
        }
    }
}

// MARK: - Preview
struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        let grocery1 = Grocery.new(name: "Milk")
        grocery1.purchasedAmount = 2
        grocery1.unitPrice = 0.99
        
        let grocery2 = Grocery.new(name: "Butter")
        grocery2.purchasedAmount = 0
        grocery2.unitPrice = 0.99
        
        return Group {
            GroceryRow(grocery: grocery1, isEditing: true)
                .environment(\.colorScheme, .dark)
                .background(Color.black)
            GroceryRow(grocery: grocery2, isEditing: false)
        }
        .environment(\.managedObjectContext, CoreDataHelper.context)
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
