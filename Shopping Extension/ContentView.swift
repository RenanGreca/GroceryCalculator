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
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: GroceryItem.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)],
                  predicate: NSPredicate(value: true),
                  animation: .spring())
    var fetchedGroceries: FetchedResults<GroceryItem>

    
    var body: some View {
        let total = fetchedGroceries.reduce(0) { $0 + $1.price }
        let totalPrice = Formatter().currency.string(for: total) ?? "0"
        
        return List {
            ForEach(fetchedGroceries, id: \.self) { grocery in
                Text("\(grocery.name!) - \(grocery.visibleUnitPrice)")
            }
            Text("Total: \(totalPrice)")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.environmentObject(GroceryItems.withSampleData)
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
