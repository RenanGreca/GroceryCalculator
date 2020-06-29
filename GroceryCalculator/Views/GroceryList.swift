//
//  GroceryList.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import WatchConnectivity

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
                            ListRow(groceryItem: grocery, showBuyItemPopUp: self.showBuyItemPopUp(groceryItem:))
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
                .navigationBarItems(leading: Button(action: {
                    self.groceryItems.clear()
                }, label: {
                    Text("Clear")
                }))
                .padding(.bottom, keyboard.currentHeight-35)
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
        Group {
        GroceryList().environmentObject(GroceryItems())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
            .previewDisplayName("iPhone 11 Pro")
        
        GroceryList().environmentObject(GroceryItems())
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
            .previewDisplayName("iPad Pro (11-inch)")
        }
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

class SessionDelegate: NSObject, WCSessionDelegate {
    
    var wcSession: WCSession! = nil
    
    func activate() {
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
    }
    
    func sendData() {
        wcSession.sendMessage(["Hello": 1], replyHandler: nil) {
            error in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}
