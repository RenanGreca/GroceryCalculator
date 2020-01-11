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
        XCTAssertNotNil(groceries)
    }
    
    func testInsertAndFetch() {
        let item = GroceryItem(name: "Banana")
        item.save()
        let groceries = GroceryItem.fetchAll()
        
        XCTAssertEqual(item, groceries.first!)
    }
    
    func testInsertAndUpdate() {
        var item = GroceryItem(name: "Banana")
        item.save()
        
        var groceries = GroceryItem.fetchAll()
        XCTAssertEqual(item, groceries.first!)
        
        // Change something in the item, save and test again
        item.amount = 2
        item.save()
        
        groceries = GroceryItem.fetchAll()
        XCTAssertEqual(item, groceries.first!)
    }
    
    func testInsertTwoItems() {
        let item1 = GroceryItem(name: "Banana")
        item1.save()
        
        let item2 = GroceryItem(name: "Apple")
        item2.save()

        let groceries = GroceryItem.fetchAll()
        XCTAssertEqual(groceries.count, 2)
    }

}
