//
//  testTests.swift
//  testTests
//
//  Created by Filipe Santo on 28/10/2021.
//

import XCTest
@testable import test

class testTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExchanges() throws {
        let a = AmountValue.initialize(currencyCode: "EUR", rates: ["USD":1.1])
    
        XCTAssertEqual(<#T##expression1: Equatable##Equatable#>,
                       <#T##expression2: Equatable##Equatable#>)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
