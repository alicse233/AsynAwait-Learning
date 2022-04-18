//
//  ViewController.swift
//  AsynAwait Learning
//
//  Created by sreelekh N on 18/04/22.
//

import UIKit

struct User: Codable {
    let name: String
}

class ViewController: UIViewController, UITableViewDataSource {
    
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    
    private var users = [User]()
    
    private let tableView: UITableView = {
        var tbl = UITableView()
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tbl
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // traditional fetch user function to be called like this
        getUsers {
            users in
//            var nn = users[0]
//            nn.append(contentsOf: "-->")
        }
        
        // add table view
        view.addSubview(tableView)
        //defin its size
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        // async style
        Task {
            let users = await fetchUsers()
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }

    //tradittional call back mechanism used for async operations
    func getUsers(onCompletion: ([String]) -> Void) {
        
    }
    
    // implementation with actual async
    func fetchUsers() async -> [User] {

        guard let url = url else {
            return []
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            return []
        }
    }
}

