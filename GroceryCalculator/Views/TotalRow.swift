//
//  TotalRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct TotalRow: View {
    var totalPrice: String
    
    var body: some View {
        HStack {
            Text("Total").font(.title).bold()
            Spacer()
            Text("\(totalPrice)").bold()
        }
        .padding()
    }

}

struct TotalRow_Previews: PreviewProvider {
    static var previews: some View {
        TotalRow(totalPrice: "12.39")
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
