//
//  ViewController.swift
//  Practice-Problem
//
//  Created by Mikaela Caron on 10/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    let todos = ["hello", "does", "this work?"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        guard cell != nil else {
//            return UITableViewCell()
//        }
        
        cell.textLabel?.text = todos[indexPath.row]
        
        return cell
    }
}
