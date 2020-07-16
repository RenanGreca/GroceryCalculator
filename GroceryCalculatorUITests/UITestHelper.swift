//
//  UITestHelper.swift
//  GroceryCalculatorUITests
//
//  Created by Renan Greca on 16/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation
import XCTest
import CoreData

public class GroceryApp: XCUIApplication {
    
    override init() {
        super.init()
        self.launch()
    }
    
    func addGroceryField() throws -> NewGroceryField {
        let field = tables.textFields["Add a grocery"]
        
        if !field.waitForExistence(timeout: 5) {
            throw GroceryError.elementDoesNotExist("Add grocery field")
        }
        
        return NewGroceryField(app: self, element: field)
    }
    
}

class GroceryUIElement: XCUIElement {
    
    let app: XCUIApplication
    let element: XCUIElement
    
    init(app: XCUIApplication, element: XCUIElement) {
        self.app = app
        self.element = element
    }
}

class NewGroceryField: GroceryUIElement {
    
    func type(text: String) throws {
        element.tap()
        element.typeText(text+"\n")
//        element.
    }
    
}

enum GroceryError: Error {
    case elementDoesNotExist(String)
}

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
