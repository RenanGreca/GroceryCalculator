//
//  GroceryItemTests.swift
//  GroceryCalculatorTests
//
//  Created by Renan Greca on 03/05/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import XCTest
@testable import GroceryCalculator

class GroceryItemTests: XCTestCase {
    
    var groceryItem: Grocery!

    override func setUpWithError() throws {
        groceryItem = Grocery.new(name: "Apple")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetUnitPriceWithOneDigit() {
        let newPrice = "1"
        groceryItem.visibleUnitPrice = newPrice
        
        XCTAssertEqual(groceryItem.unitPrice, 0.01)
        XCTAssertEqual(groceryItem.visibleUnitPrice, Formatter().number.string(from: 0.01)!)
    }
    
    func testSetUnitPriceWithTwoDigits() {
        let newPrice = "10"
        groceryItem.visibleUnitPrice = newPrice
        
        XCTAssertEqual(groceryItem.unitPrice, 0.10)
        XCTAssertEqual(groceryItem.visibleUnitPrice, Formatter().number.string(from: 0.10)!)
    }
    
    func testSetUnitPriceWithThreeDigits() {
        let newPrice = "321"
        groceryItem.visibleUnitPrice = newPrice
        
        XCTAssertEqual(groceryItem.unitPrice, 3.21)
        XCTAssertEqual(groceryItem.visibleUnitPrice, Formatter().number.string(from: 3.21)!)
    }

}
