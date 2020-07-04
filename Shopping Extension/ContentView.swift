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
    @FetchRequest(entity: Grocery.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)],
                  predicate: NSPredicate(value: true),
                  animation: .spring())
    var fetchedGroceries: FetchedResults<Grocery>

    
    var body: some View {
        let total = fetchedGroceries.reduce(0) { $0 + $1.price }
        let totalPrice = Formatter().currency.string(for: total) ?? "0"
        print("Updating list... Grocerycount: \(fetchedGroceries.count)")
        print("Updating price... \(totalPrice)")
        return VStack {
            List {
                ForEach(fetchedGroceries, id: \.self) { grocery in
                    WatchRow(grocery: grocery)
                }
                .onDelete() { indexSet in
                    let grocery = self.fetchedGroceries[indexSet.first!]
                    self.context.delete(grocery)
                    CoreDataHelper.saveContext()
                }
                .onMove() { source, destination in
                    var list = self.fetchedGroceries.compactMap() { $0 }
                    
                    list.move(fromOffsets: source, toOffset: destination)
                    
                    for i in 0..<list.count {
                        list[i].updatePosition(index: i)
                    }
                    
                    CoreDataHelper.saveContext()
                }
            }
            .listStyle(CarouselListStyle())
            HStack {
                Spacer()
                Text("Total: \(totalPrice)")
                    .padding(1)
                Spacer()
            }
            .background(Color.black)
            
        }
        .navigationBarTitle("Grocery List")
        .edgesIgnoringSafeArea(.bottom)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let grocery1 = Grocery.new(name: "Milk")
        grocery1.purchasedAmount = 2
        grocery1.unitPrice = 0.89
        
        let grocery2 = Grocery.new(name: "Butter")
        grocery2.purchasedAmount = 0
        grocery2.unitPrice = 0.99
        
        return Group {
            ContentView()
                .environment(\.managedObjectContext, (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext)
                .previewDevice("Apple Watch Series 5 - 40mm")
            
            ContentView()
                .environment(\.managedObjectContext, (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext)
                .previewDevice("Apple Watch Series 3 - 38mm")
        }
    }
}

struct WatchRow: View {
    @ObservedObject var grocery: Grocery
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack {
            if (grocery.purchasedAmount > 0) {
                PurchasedRow(grocery: grocery)
            } else {
                UnpurchasedRow(grocery: grocery)
            }
        }
    }
}

extension WatchRow {
    
    struct PurchasedRow: View {
        @ObservedObject var grocery: Grocery
        @Environment(\.managedObjectContext) var context

        var body: some View {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        self.grocery.purchasedAmount = 0
                        try? self.context.save()
                    }
                                
                Text(grocery.name)
                    .foregroundColor(.gray)
                    .frame(height: 25)
                    .font(.system(.body, design: .rounded))

                Spacer()
                Text("\(grocery.readablePrice)")
                    .onTapGesture {
                        self.grocery.purchasedAmount = self.grocery.desiredAmount
                    }
            }
        }
    }
    
    struct UnpurchasedRow: View {
        @ObservedObject var grocery: Grocery
        @Environment(\.managedObjectContext) var context
        
        var body: some View {
            
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        // Once we choose to buy a grocery, let's automatically say that we purchased the amount we wanted.
                        self.grocery.purchasedAmount = self.grocery.desiredAmount
                        //                    self.pushed = true
                }
                
                Text(self.grocery.name)
                    .frame(height: 25)
                    .font(.system(.body, design: .rounded))
                
                Spacer()

            }
        }
    }
}

