//
//  ViewController.swift
//  Practice-Problem
//
//  Created by Mikaela Caron on 10/5/21.
//

import UIKit

enum HttpError: Error {
    case badResponse
    case badData
    case decodeError
    case requestError
    case urlError
}

final class ViewController: UIViewController {
    
    var todos = [Todo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData { result in
            switch result {
            case .failure(let error):
                print("❌ \(error)")
            case .success(let todos):
                self.todos = todos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func getData(completion: @escaping (Result<[Todo], HttpError>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            completion(.failure(.requestError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.badData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            guard data != nil else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let todos = try decoder.decode([Todo].self, from: data!)
                completion(.success(todos))
            } catch {
                completion(.failure(.decodeError))
            }
            
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = todos[indexPath.row].title
        
        return cell
    }
}
