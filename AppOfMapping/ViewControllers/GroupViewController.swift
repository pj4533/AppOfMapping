//
//  GroupViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/19/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomGroupDelegate {

    var groupType : MonsterGroup.GroupType?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "\(self.groupType?.rawValue.capitalized ?? "")"
        
        if self.groupType == .custom {
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: self.tableView.isEditing ? .done : .edit, target: self, action:#selector(editTapped(_:))),
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addTapped(_:)))
            ]
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "CustomGroupViewController") as? CustomGroupViewController {
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .formSheet
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: self.tableView.isEditing ? .done : .edit, target: self, action:#selector(editTapped(_:))),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addTapped(_:)))
        ]
    }

    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        if indexPath.section == 0 {
            appdelegate.monsterDataSource.removeGroupFiltersOfType(self.groupType)
        } else {
            let groups = appdelegate.monsterDataSource.getSupportedGroups()
            let group = groups.filter({$0.groupType == self.groupType})[indexPath.row]
            if tableView.isEditing {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "CustomGroupViewController") as? CustomGroupViewController {
                    vc.delegate = self
                    vc.customGroup = group
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .formSheet
                    self.present(nav, animated: true, completion: nil)
                }
            } else {
                if appdelegate.monsterDataSource.getGroupFilter().contains(group) {
                    appdelegate.monsterDataSource.removeGroupFilter(group)
                } else {
                    appdelegate.monsterDataSource.addGroupFilter(group)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
            let thisTypeGroupFilter = appdelegate.monsterDataSource.getGroupFilter().filter({$0.groupType == self.groupType})
            let groups = appdelegate.monsterDataSource.getSupportedGroups()
            let group = groups.filter({$0.groupType == self.groupType})[indexPath.row]
            if thisTypeGroupFilter.contains(group) {
                appdelegate.monsterDataSource.removeGroupFilter(group)
            }
            
            appdelegate.monsterDataSource.deleteCustomGroupFilter(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}

        if (self.groupType == .custom) &&
            (indexPath.section == 1) &&
            (indexPath.row >= appdelegate.monsterDataSource.getBuiltInCustomGroups().count) {
            return true
        }
        
        return false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        
        return appdelegate.monsterDataSource.getSupportedGroups().filter({$0.groupType == self.groupType}).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
        cell.textLabel?.textColor = UIColor.fromHex(0x454545)
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        let groups = appdelegate.monsterDataSource.getSupportedGroups()
        let thisTypeGroupFilter = appdelegate.monsterDataSource.getGroupFilter().filter({$0.groupType == self.groupType})
        cell.accessoryType = .none
        
        if indexPath.section == 0 {
            if thisTypeGroupFilter.isEmpty {
                cell.accessoryType = .checkmark
            }
            cell.textLabel?.text = "All"
        } else {
            let group = groups.filter({$0.groupType == self.groupType})[indexPath.row]

            if group.groupType == .custom {
                cell.textLabel?.text = group.name ?? "Custom Group"
            } else {
                cell.textLabel?.text = group.values?.map({$0.capitalized}).joined(separator: ", ")
            }
            
            if thisTypeGroupFilter.contains(group) {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }

    // MARK: CustomGroupDelegate
    
    func updatedGroup(_ group: MonsterGroup?) {
        self.tableView.reloadData()
    }
}
