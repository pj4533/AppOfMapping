//
//  AddEnemyViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/9/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol AddEnemyDelegate {
    func didTapMonster(_ monster: Monster)
}

class AddEnemyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var delegate : AddEnemyDelegate?
    var filteredMonsters : [Monster] = []
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.tableview.rowHeight = UITableView.automaticDimension
        
        self.updateUI()
    }
    
    func updateUI() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        self.filteredMonsters = appdelegate.monsterDataSource.allMonsters
        self.tableview.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let monster = self.filteredMonsters[indexPath.row]
        self.delegate?.didTapMonster(monster)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.filteredMonsters.count) creatures"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMonsters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let monster = self.filteredMonsters[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.fromHex(0x454545)
        cell.textLabel?.text = "\(monster.name ?? "") (CR \(monster.challengeRating ?? ""))"
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
        cell.detailTextLabel?.text = monster.environment

        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        if searchText == "" {
            self.filteredMonsters = appdelegate.monsterDataSource.allMonsters
        } else {
            self.filteredMonsters = appdelegate.monsterDataSource.allMonsters.filter({
                (
                    ($0.name?.lowercased().contains(searchText.lowercased()) ?? false) ||
                    ($0.challengeRating == searchText) ||
                    ($0.environment?.lowercased().contains(searchText.lowercased()) ?? false) ||
                    ($0.subtype?.lowercased().contains(searchText.lowercased()) ?? false) ||
                    ($0.alignment?.lowercased().contains(searchText.lowercased()) ?? false) ||
                    ($0.type?.lowercased().contains(searchText.lowercased()) ?? false)
                )
            })
        }

        self.tableview.reloadData()
    }
}
