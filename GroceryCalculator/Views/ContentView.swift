//
//  ContentView.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
//        TabView(selection: $selection){
            // Tab 1
            GroceryList()
                .tabItem {
                    VStack {
                        Image(systemName: "cart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text("List")
                    }
            }
            
//            .tag(0)
//            
//            // Tab 2
//            PurchaseList()
//                .tabItem {
//                    VStack {
//                        Image(systemName: "eurosign.circle")
//                        Text("Purchase")
//                    }
//            }
//            .tag(1)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
