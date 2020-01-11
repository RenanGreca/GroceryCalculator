//
//  TotalRow.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI

struct TotalRow: View {
    var totalPrice: Double
    
    var body: some View {
        HStack {
            Text("Total").font(.title).fontWeight(.bold)
            Spacer()
            Text("€\(readablePrice)")
        }
        .padding()
    }
    
    var readablePrice: String {
        String(format: "%.2f", totalPrice)
    }
}

struct TotalRow_Previews: PreviewProvider {
    static var previews: some View {
        TotalRow(totalPrice: 12.39)
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
