//
//  GroceryCalculatorUITests.swift
//  GroceryCalculatorUITests
//
//  Created by Renan Greca on 17/02/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import XCTest

class GroceryCalculatorUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAddItem() {
                
        let app = XCUIApplication()
        app.launch()
//        app.menuBarItems["AddItem"].tap()
        app.buttons["AddItem"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Apple")
        app.buttons["OK"].tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
