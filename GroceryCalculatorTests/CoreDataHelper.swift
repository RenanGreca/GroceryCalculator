//
//  CoreDataHelper.swift
//  GroceryCalculatorTests
//
//  Created by Renan Greca on 17/02/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation
import CoreData

func testingContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = persistentStoreCoordinator
    
    return context
}
