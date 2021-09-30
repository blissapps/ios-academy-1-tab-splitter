//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit



class VCCoordinator {
    let blissModel = BlissModel()
    var vc : ViewController?
    var svc : SecondViewController?
    
    
    func delete() {
        vc?.users?.removeAll()
        vc?.rest = 0
        vc?.total = 0
        vc?.restLabel.text = vc?.rest?.displayText
        vc?.totalLabel.text = vc?.total?.displayText
        vc?.tableView.reloadData()
    }
    
    func uptade(int: Int) {
        svc = vc?.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        vc?.navigationController?.pushViewController(svc!, animated: true)
        svc?.changeTitleButton(int: int)
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
