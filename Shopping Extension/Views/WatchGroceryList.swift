//
//  ContentView.swift
//  Shopping Extension
//
//  Created by Renan Greca on 08/05/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import WatchConnectivity

struct WatchGroceryList: View {
    
    @FetchRequest(entity: Grocery.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)],
                  predicate: NSPredicate(format: "visible = %d", true),
                  animation: .spring())
    var fetchedGroceries: FetchedResults<Grocery>

    
    var body: some View {
        let total = fetchedGroceries.reduce(0) { $0 + $1.price }
        let totalPrice = Formatter().currency.string(for: total) ?? "0"
        return VStack {
            List {
                ForEach(fetchedGroceries, id: \.self) { grocery in
                    NavigationLink(destination:
                        WatchGroceryDetail(grocery: grocery)) {
                            WatchGroceryRow(grocery: grocery)
                    }
                }
                .onDelete() { indexSet in
                    let grocery = self.fetchedGroceries[indexSet.first!]
                    grocery.visible = false
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
                Text("Total")
                    .padding(1)
                Text("\(totalPrice)")
                    .bold()
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
            WatchGroceryList()
                .environment(\.managedObjectContext, (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext)
                .previewDevice("Apple Watch Series 5 - 40mm")
            
            WatchGroceryList()
                .environment(\.managedObjectContext, (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext)
                .previewDevice("Apple Watch Series 3 - 38mm")
        }
    }
}
