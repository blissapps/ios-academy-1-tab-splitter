//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

class   SVCCoordinator: Coordinator {
    let blissModel: BlissModel
    let vc: ViewController
    let svc: SecondViewController
    
    init(bliss:BlissModel, ViewController:ViewController, SecondViewController:SecondViewController) {
        blissModel = BlissModel()
        self.vc = ViewController
        self.svc = SecondViewController
    }
    
    func delete() {
    }
    
    func uptade(int: Int) {
        
        
    }
}
