//
//  Formatter.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 01/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation
import SwiftUI

struct Formatter {
    

    var number: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.isLenient = true
        return formatter
    }

    var currency: NumberFormatter {
        let formatter = self.number
        formatter.numberStyle = .currency
        return formatter
    }


}
