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
        let u1 = BillItem(name: "Test", amount: zeroEur, changedUser: false)
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

    func testBillSplitterEngine_save_simpleUnchangedUser() throws {
        b.billAmount = threeEur
        let u = BillItem(name: "Test", amount: zeroEur, changedUser: false)
        b.users = [u]
        XCTAssertEqual(b.restAmount, zeroEur)
        XCTAssertEqual(b.users[0].amount, threeEur)
    }

    func testBillSplitterEngine_save_simpleChangedUser() throws {
        b.billAmount = threeEur
        let u = BillItem(name: "Test", amount: oneEur, changedUser: true)
        b.users = [u]
        XCTAssertEqual(b.restAmount, twoEur)
        XCTAssertEqual(b.users[0].amount, oneEur)
    }

    func testBillSplitterEngine_save_divisionRemainderUnchangedUser() throws {
        b.billAmount = oneEur
        let u1 = BillItem(name: "Test1", amount: zeroEur, changedUser: false)
        let u2 = BillItem(name: "Test2", amount: zeroEur, changedUser: false)
        let u3 = BillItem(name: "Test3", amount: zeroEur, changedUser: false)
        b.users.append(u1)
        b.users.append(u2)
        b.users.append(u3)
        XCTAssertEqual(b.restAmount, zeroDot01Eur)
        XCTAssertEqual(b.users[0].amount, zeroDot33Eur)
        XCTAssertEqual(b.users[1].amount, zeroDot33Eur)
        XCTAssertEqual(b.users[2].amount, zeroDot33Eur)
    }

    func testBillSplitterEngine_save_divisionRemainderReplaceUser() throws {
        b.billAmount = oneEur
        let u1 = BillItem(name: "Test1", amount: zeroEur, changedUser: false)
        let u2 = BillItem(name: "Test2", amount: zeroEur, changedUser: false)
        let u3 = BillItem(name: "Test3", amount: zeroEur, changedUser: false)
        b.users.append(u1)
        b.users.append(u2)
        b.users.replace(id: u1.id, user: u3)
        XCTAssertEqual(b.restAmount, zeroEur)
        XCTAssertEqual(b.users[0].amount, zeroDot5Eur)
        XCTAssertEqual(b.users[1].amount, zeroDot5Eur)
        XCTAssertEqual(b.users[0].id, u3.id)
    }

    func testBillSplitterEngine_save_negativeRemainder() throws {
        b.billAmount = oneEur
        let u1 = BillItem(name: "Test1", amount: twoEur, changedUser: true)
        let u2 = BillItem(name: "Test1", amount: zeroEur, changedUser: false)
        b.users.append(u1)
        b.users.append(u2)
        XCTAssertEqual(b.restAmount, oneEur.symmetric)
        XCTAssertEqual(b.users[0].amount, twoEur)
        XCTAssertEqual(b.users[1].amount, zeroEur)
    }

}
