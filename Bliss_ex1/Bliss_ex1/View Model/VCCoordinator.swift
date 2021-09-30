//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

class VCCoordinator: Coordinator {
    
    let blissModel = BlissModel()
    var vc : ViewController?
    var svc : SecondViewController?
    var bill: Double?
    var rest: Double?
    
    var selectedBillItem: BillItem?
    var billItems: [BillItem]?

    init(vc: ViewController?) {
        self.vc = vc
        vc?.coordinator = self
        billItems = []
    }
    
    func delete() {
        vc?.users?.removeAll()
        self.rest = 0
        self.bill = 0
        vc?.restLabel.text = "0€"
        vc?.totalLabel.text = "0€"
        vc?.tableView.reloadData()
    }
    
    func uptade(int: Int) {
        svc = vc?.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        vc?.navigationController?.pushViewController(svc!, animated: true)
        svc?.changeTitleButton(int: int)
        svc?.coordinator = self
    }
    
    func setBill(bill: Double) {
        self.bill = bill
    }
    
    func addPerson(name: String, value: Double) {
        let personAndBill = BillItem(name: name, value: value)
        billItems?.append(personAndBill)
    }
}

extension Optional where Wrapped == Double {
    var displayText: String {
        (self ?? 0).displayText
    }
}

extension Double {
    var displayText: String {
        return String(format: "%f", self)
    }
}

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
