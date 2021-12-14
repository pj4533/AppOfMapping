//
//  GroupsViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/17/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Creature Group Filters"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
            appdelegate.monsterDataSource.setGroupFilter([])
            self.tableview.reloadData()
        } else {
            let grouptype = MonsterGroup.GroupType.allCases[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as? GroupViewController {
                vc.groupType = grouptype
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        
        return MonsterGroup.GroupType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
        cell.textLabel?.textColor = UIColor.fromHex(0x454545)
        
        let grouptype = MonsterGroup.GroupType.allCases[indexPath.row]

        cell.detailTextLabel?.textColor = UIColor.fromHex(0xa7a7a7)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)

        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        if indexPath.section == 0 {
            cell.accessoryType = .none
            cell.textLabel?.text = "Reset Filters"
            cell.detailTextLabel?.text = ""
        } else {
            cell.textLabel?.text = grouptype.rawValue.capitalized
            let count = appdelegate.monsterDataSource.getGroupFilter().filter({$0.groupType == grouptype}).count
            cell.detailTextLabel?.text = count == 0 ? "All" : "\(count) selected"
        }
        


        return cell
    }
    
}
