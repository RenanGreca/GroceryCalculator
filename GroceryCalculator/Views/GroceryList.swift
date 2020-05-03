//
//  GroceryList.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct GroceryList: View {
    
//    @State var addItemPopUpVisible = false
//    @State var buyItemPopUpVisible = false
    @State var selectedGrocery: GroceryItem?
    
    @ObservedObject var keyboard = KeyboardResponder()
    @EnvironmentObject var groceryItems: GroceryItems
    @State private var editMode = EditMode.inactive
        
    var body: some View {
        return ZStack {
            // NavigationView including the list of groceries
            NavigationView {
                VStack {
                    List {
                        ForEach(groceryItems.list) { grocery in
                            ListRow(showBuyItemPopUp: self.showBuyItemPopUp(groceryItem:), groceryItem: grocery)
                        }.onDelete(perform: onDelete(offsets:))
                        // Blank row for adding new grocery
                        NewGroceryRow()
                    }
                    // Row showing total value of purchase
                    if (keyboard.currentHeight == 0) {
                        TotalRow(totalPrice: groceryItems.readablePrice)
                    }
                }
                .environment(\.editMode, $editMode)
                .navigationBarTitle(Text("Grocery List"))
                .navigationBarItems(leading: EditButton())
                .padding(.bottom, keyboard.currentHeight)
//                .edgesIgnoringSafeArea(.bottom)
                .animation(.easeInOut(duration: 0.16))
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        groceryItems.remove(at: offsets)
    }

    private func onMove(source: IndexSet, destination: Int) {
        groceryItems.move(from: source, to: destination)
    }
    
    private func leadingPadding() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 0.5
        }
        return 0
    }
    
    func showBuyItemPopUp(groceryItem: GroceryItem) {
        self.selectedGrocery = groceryItem
    }
}

struct GroceryList_Previews: PreviewProvider {
    static var previews: some View {
        GroceryList().environmentObject(GroceryItems())
    }
}

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height// - 110
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
