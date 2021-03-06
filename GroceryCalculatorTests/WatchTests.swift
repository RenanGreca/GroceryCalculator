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
        let array = 0.00.toArray()
        
        XCTAssertEqual(array, [0, 0, 0])
    }
    
    func testArray0001() throws {
        let array = 0.01.toArray()
        
        XCTAssertEqual(array, [0, 0, 1])
    }
    
    func testArray0010() throws {
        let array = 0.10.toArray()
        
        XCTAssertEqual(array, [0, 1, 0])
    }
    
    func testArray0100() throws {
        let array = 1.00.toArray()
        
        XCTAssertEqual(array, [1, 0, 0])
    }
    
    func testArray1000() throws {
        let array = 10.00.toArray()
        
        XCTAssertEqual(array, [10, 0, 0])
    }


    func testDouble0000() throws {
        let double = [0, 0, 0].toDouble()
        
        XCTAssertEqual(double, 0.00)
    }
    
    func testDouble0001() throws {
        let double = [0, 0, 1].toDouble()
        
        XCTAssertEqual(double, 0.01)
    }
    
    func testDouble0010() throws {
        let double = [0, 1, 0].toDouble()
        
        XCTAssertEqual(double, 0.10)
    }
    
    func testDouble0100() throws {
        let double = [1, 0, 0].toDouble()
        
        XCTAssertEqual(double, 1.00)
    }
    
    func testDouble1000() throws {
        let double = [10, 0, 0].toDouble()
        
        XCTAssertEqual(double, 10.00)
    }

    
}
