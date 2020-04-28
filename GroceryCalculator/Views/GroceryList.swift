//
//  GroceryList.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct GroceryList: View {
    
    @State var addItemPopUpVisible = false
    @State var buyItemPopUpVisible = false
    @State var selectedGrocery: GroceryItem?
    
    @EnvironmentObject var groceryItems:GroceryItems
    @State private var editMode = EditMode.inactive
    
    @State var newGrocery = ""
    
    var body: some View {
        return ZStack {
            // NavigationView including the list of groceries
            NavigationView {
                VStack {
                    List {
                        ForEach(groceryItems.list) { grocery in
                            ListRow(groceryItem: .constant(grocery))
                        }.onDelete(perform: onDelete(offsets:))
                        NewGroceryRow()
                    }
                    TotalRow(totalPrice: groceryItems.total)
                }
                .environment(\.editMode, $editMode)
                .navigationBarTitle(Text("Grocery List"))
                .navigationBarItems(leading: EditButton())
            }
                        
            if (addItemPopUpVisible) {
                // If the pop-up should be visible, add a dark background
                Color.black.opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.addItemPopUpVisible.toggle()
                    }
                
                AddItemPopUp(okAction: addItem(name:), cancelAction: {
                    self.addItemPopUpVisible.toggle()
                })
            }
            
            if (buyItemPopUpVisible) {
                Color.black.opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.buyItemPopUpVisible.toggle()
                    }
                
                BuyItemPopUp(amountString: "\(self.selectedGrocery!.amount)",
                    unitPriceString: String(format: "%.2f", self.selectedGrocery!.unitPrice),
                okAction: buyItem(amount:unitPrice:), cancelAction: {
                    self.buyItemPopUpVisible.toggle()
                })
            }
        }
    }
    
//    private var addButton: some View {
//        switch editMode {
//        case .inactive:
//            return AnyView(Button(action: onAdd) {
//                Image(systemName: "plus")
//            }.accessibility(identifier: "AddItem"))
//        default:
//            return AnyView(EmptyView())
//        }
//    }
    
    private func onDelete(offsets: IndexSet) {
        groceryItems.list.remove(atOffsets: offsets)
    }

    private func onMove(source: IndexSet, destination: Int) {
        groceryItems.list.move(fromOffsets: source, toOffset: destination)
    }
    
    private func onAdd() {
        self.addItemPopUpVisible.toggle()
    }
    
    func addItem(name: String) {
        groceryItems.add(name: name)
        self.addItemPopUpVisible.toggle()
    }
    
    func buyItem(amount: Int, unitPrice: Double) {
        if var groceryItem = self.selectedGrocery?.duplicate() {
            groceryItem.amount = amount
            groceryItem.unitPrice = unitPrice
            groceryItem.save()
        }
        self.selectedGrocery = nil
        self.groceryItems.refresh()
        self.buyItemPopUpVisible.toggle()
    }
}

struct GroceryList_Previews: PreviewProvider {
    static var previews: some View {
        GroceryList().environmentObject(GroceryItems.withSampleData)
    }
}
