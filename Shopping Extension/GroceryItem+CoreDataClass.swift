//
//  GroceryItem+CoreDataClass.swift
//  Shopping Extension
//
//  Created by Renan Greca on 02/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GroceryItem)
public class GroceryItem: NSManagedObject {
    var unitPriceString: String = ""
}
