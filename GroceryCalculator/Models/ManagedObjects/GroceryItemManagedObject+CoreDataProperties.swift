//
//  GroceryItemManagedObject+CoreDataProperties.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 28/04/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//
//

import Foundation
import CoreData


extension GroceryItemManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroceryItemManagedObject> {
        return NSFetchRequest<GroceryItemManagedObject>(entityName: "GroceryItem")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var unitPrice: Double

}
