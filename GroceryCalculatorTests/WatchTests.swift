//
//  WatchTests.swift
//  GroceryCalculatorTests
//
//  Created by Renan Greca on 10/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import XCTest
@testable import GroceryCalculator

class WatchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testArray0000() throws {
        let array = Formatter.arrayFrom(double: 0.00)
        
        XCTAssertEqual(array, [0, 0, 0])
    }
    
    func testArray0001() throws {
        let array = Formatter.arrayFrom(double: 0.01)
        
        XCTAssertEqual(array, [0, 0, 1])
    }
    
    func testArray0010() throws {
        let array = Formatter.arrayFrom(double: 0.10)
        
        XCTAssertEqual(array, [0, 1, 0])
    }
    
    func testArray0100() throws {
        let array = Formatter.arrayFrom(double: 1.00)
        
        XCTAssertEqual(array, [1, 0, 0])
    }
    
    func testArray1000() throws {
        let array = Formatter.arrayFrom(double: 10.00)
        
        XCTAssertEqual(array, [10, 0, 0])
    }


    func testDouble0000() throws {
        let double = Formatter.doubleFrom(array: [0, 0, 0])
        
        XCTAssertEqual(double, 0.00)
    }
    
    func testDouble0001() throws {
        let double = Formatter.doubleFrom(array: [0, 0, 1])
        
        XCTAssertEqual(double, 0.01)
    }
    
    func testDouble0010() throws {
        let double = Formatter.doubleFrom(array: [0, 1, 0])
        
        XCTAssertEqual(double, 0.10)
    }
    
    func testDouble0100() throws {
        let double = Formatter.doubleFrom(array: [1, 0, 0])
        
        XCTAssertEqual(double, 1.00)
    }
    
    func testDouble1000() throws {
        let double = Formatter.doubleFrom(array: [10, 0, 0])
        
        XCTAssertEqual(double, 10.00)
    }

    
}
