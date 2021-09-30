//
//  ViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit

var coordinator = VCCoordinator()

class ViewController: UIViewController {
    var users: [(String, Double)]?
    var rest: Double?
    var total: Double?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coordinator.vc = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func restartButton(_ sender: Any) {
        coordinator.delete()
    }
    
    @IBAction func addButton(_ sender: Any) {
        coordinator.uptade(int: 0)
    }
}


//MARK: - TableView

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
        coordinator.uptade(int: 1)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users?[indexPath.row].0
        //falta fazer algoritmo para o restlabel
        return cell
    }
    
}




