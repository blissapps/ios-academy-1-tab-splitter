//
//  BillSplitterAppUITests.swift
//  BillSplitterAppUITests
//
//  Created by Filipe Santo on 29/09/2021.
//

import XCTest

class BillSplitterAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangeCurrencyOfTotalAmount() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let totalAmountTextField = app.textFields["TotalAmountTextField"]
        XCTAssertTrue(totalAmountTextField.waitForExistence(timeout: 10))
        let currencyButton = totalAmountTextField.buttons["CurrencyButton"]
        XCTAssertTrue(currencyButton.waitForExistence(timeout: 10))
        currencyButton.tap()

        let pickerWheel = app.pickers["CurrencyPickerView"]

        XCTAssertTrue(pickerWheel.waitForExistence(timeout: 10))
        pickerWheel.pickerWheels.firstMatch.swipeUp()
        let toolbar = app.toolbars["CurrencyPickerViewToolbar"]
        XCTAssertTrue(toolbar.waitForExistence(timeout: 10))
        toolbar.buttons["Done"].tap()
    }
    
    func testTapResetButton() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let totalAmountTextField = app.textFields["TotalAmountTextField"]
        XCTAssertTrue(totalAmountTextField.waitForExistence(timeout: 10))
        let currencyButton = totalAmountTextField.buttons["CurrencyButton"]
        XCTAssertTrue(currencyButton.waitForExistence(timeout: 10))
        currencyButton.tap()

        let pickerWheel = app.pickers["CurrencyPickerView"]

        XCTAssertTrue(pickerWheel.waitForExistence(timeout: 10))
        pickerWheel.pickerWheels.firstMatch.swipeUp()
        let toolbar = app.toolbars["CurrencyPickerViewToolbar"]
        XCTAssertTrue(toolbar.waitForExistence(timeout: 10))
        toolbar.buttons["Done"].tap()
        
        let deleteButton = XCUIApplication().navigationBars["Tab Splitter"].buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 10))
        deleteButton.tap()
    }
    
    func testTapAddButton() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let addButton = app.buttons["addButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 10))
        addButton.tap()
        
        let nameTextField = app.textFields["svNameTextField"]
        nameTextField.tap()
        nameTextField.typeText("Test")
        XCTAssertTrue(nameTextField.waitForExistence(timeout: 10))

        let valueTextField = app.textFields["svValueTextField"]
        XCTAssertTrue(valueTextField.waitForExistence(timeout: 10))
        valueTextField.tap()
        valueTextField.typeText("12345")
        XCTAssertTrue(nameTextField.waitForExistence(timeout: 10))
        
        let currencyButton = valueTextField.buttons["CurrencyButton"]
        XCTAssertTrue(currencyButton.waitForExistence(timeout: 10))
        currencyButton.tap()

        let pickerWheel = app.pickers["CurrencyPickerView"]

        XCTAssertTrue(pickerWheel.waitForExistence(timeout: 10))
        pickerWheel.pickerWheels.firstMatch.swipeUp()
        let toolbar = app.toolbars["CurrencyPickerViewToolbar"]
        XCTAssertTrue(toolbar.waitForExistence(timeout: 10))
        toolbar.buttons["Done"].tap()
        
        let saveOrAdd = app.buttons["saveOrAdd"]
        XCTAssertTrue(saveOrAdd.waitForExistence(timeout: 10))
        saveOrAdd.tap()
    }
}
