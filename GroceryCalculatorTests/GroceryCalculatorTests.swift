//
//  GroceryCalculatorTests.swift
//  GroceryCalculatorTests
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import XCTest
@testable import GroceryCalculator

class GroceryCalculatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        CoreDataHelper.context = testingContext()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInsertItem() {
        let item = GroceryItem(name: "Banana")
        item.save()
        XCTAssertNotNil(item)
    }
    
    func testFetchAll() {
        let groceries = GroceryItem.fetchAll()
        XCTAssertEqual(groceries.count, 0)
    }
    
    func testInsertAndFetch() {
        let item = GroceryItem(name: "Banana")
        item.save()
        let groceries = GroceryItem.fetchAll()
        
        XCTAssertEqual(groceries.count, 1)
        XCTAssertEqual(item, groceries.first!)
    }
    
    func testInsertAndUpdate() {
        let item = GroceryItem(name: "Banana")
        item.save()
        
        var groceries = GroceryItem.fetchAll()
        XCTAssertEqual(item, groceries.first!)
        
        // Change something in the item, save and test again
        item.purchasedAmount = 2
        item.save()
        
        groceries = GroceryItem.fetchAll()
        XCTAssertEqual(item, groceries.first!)
    }
    
    func testInsertTwoItems() {
        let groceryItems = GroceryItems()
        
        let prevAmount = groceryItems.list.count
        
        let item1 = GroceryItem(name: "Banana")
        item1.save()

        let item2 = GroceryItem(name: "Apple")
        item2.save()

        groceryItems.refresh()
        XCTAssertEqual(groceryItems.list.count, prevAmount+2)
        XCTAssertEqual(item1, groceryItems.list.first!)
    }

}
