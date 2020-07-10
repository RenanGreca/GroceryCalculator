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
        let item = Grocery.new(name: "Banana")
        XCTAssertNotNil(item)
    }


}
