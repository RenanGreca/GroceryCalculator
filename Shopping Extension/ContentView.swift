//
//  ContentView.swift
//  Shopping Extension
//
//  Created by Renan Greca on 08/05/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    @EnvironmentObject var groceryItems: GroceryItems
    
    var body: some View {
        List {
            ForEach(groceryItems.list) { grocery in
                Text(grocery.name)
            }
//                ForEach(groceryItems.list) { grocery in
//                    ListRow(groceryItem: grocery, showBuyItemPopUp: self.showBuyItemPopUp(groceryItem:))
//                }.onDelete(perform: onDelete(offsets:))
//                // Blank row for adding new grocery
//                NewGroceryRow()
        }
        // Row showing total value of purchase
//            if (keyboard.currentHeight == 0) {
//                TotalRow(totalPrice: groceryItems.readablePrice)
//            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GroceryItems.withSampleData)
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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

    
}
