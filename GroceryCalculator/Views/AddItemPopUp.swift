//
//  AddItemPopUp.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct AddItemPopUp: View {
    
    @State var name: String = ""
    var okAction: (_: String) -> Void
    var cancelAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Add Item")
                .font(.headline)
            TextField("Name", text: $name)
                .frame(height: 30.0)
                .border(Color.gray)
            Spacer()
            HStack {
                Button(action: {
                    self.okAction(self.name)
                }) {
                    Text("OK")
                }.frame(width: 90, height: 30)
                Button(action: {
                    self.cancelAction()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                }.frame(width: 90, height: 30)
            }
        }.padding()
        .frame(width: 200, height: 130)
            .background(Color(UIColor.systemBackground))
        .cornerRadius(5)
        .shadow(radius: 10)
    }
}

struct AddItemPopUp_Previews: PreviewProvider {
    static var previews: some View {
        AddItemPopUp(okAction: { name in
            print(name)
        }, cancelAction: {
            print("nothing added")
        })
        .previewLayout(.fixed(width: 300, height: 200))
    }
}
