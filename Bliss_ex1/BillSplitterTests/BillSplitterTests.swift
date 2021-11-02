//
//  BillSplitterTests.swift
//  BillSplitterTests
//
//  Created by Tiago Janela on 11/2/21.
//

import XCTest
//
import AmountValue
import TestUtils
//
@testable import BillSplitter


class BillSplitterTests: XCTestCase {

    var b: BillSplitterEngine!
    override func setUpWithError() throws {
        try AmountValue.initialize(currencyCode: "EUR", rates: ["EUR": oneDecimal])
        b = BillSplitterEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBillSplitterEngine_amountDidChange() throws {
        let a1 = oneEur
        var a2: AmountValue?
        b.billAmountDidChange = { newBillAmount in
            a2 = newBillAmount
            XCTAssertEqual(newBillAmount, a1)
        }
        b.billAmount = a1
        XCTAssertNotNil(a2)
    }

    func testBillSplitterEngine_usersDidChange() throws {
        let u1 = BillItem(name: "Test", amount: oneEur, changedUser: false)
        var u2: [BillItem]?
        b.usersDidChange = { newUsers in
            u2 = newUsers
            XCTAssertEqual(newUsers, [u1])
        }
        b.users = [u1]
        XCTAssertNotNil(u2)
    }

    func testBillSplitterEngine_reset() {
        b.billAmount = oneEur
        let u = BillItem(name: "Test", amount: oneEur, changedUser: false)
        b.users = [u]
        b.reset()
        XCTAssertEqual(b.billAmount, zeroEur)
        XCTAssertEqual(b.users, [])
    }

    func testBillSplitterEngine_save() throws {
        b.billAmount = threeEur
        let u = BillItem(name: "Test", amount: oneEur, changedUser: false)
        b.users = [u]
        XCTAssertEqual(b.restAmount, zeroEur)
        XCTAssertEqual(b.users[0].amount, threeEur)
    }

}
