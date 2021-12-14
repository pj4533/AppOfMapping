//
//  CustomGroupViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/17/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol CustomGroupDelegate {
    func updatedGroup(_ group: MonsterGroup?)
}

class CustomGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TextFieldCellDelegate, AddEnemyDelegate {

    var delegate : CustomGroupDelegate?
    var customGroup : MonsterGroup?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.title = "Add Custom Group"
        
        if self.customGroup == nil {
            self.customGroup = MonsterGroup()
            self.customGroup?.groupId = UUID().uuidString
            self.customGroup?.groupType = .custom
        }
        
        let times = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: times, style: .plain, target: self, action: #selector(tappedHide))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tappedSave))
    }
    
    @IBAction func tappedAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddEnemyViewController") as? AddEnemyViewController {
            vc.delegate = self
            vc.title = "Add Creature"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tappedSave() {
        let datasource = MonsterDataSource()
        datasource.saveCustomGroupFilter(self.customGroup)
        self.delegate?.updatedGroup(self.customGroup)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedHide() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        if let monsterName = self.customGroup?.values?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "StatBlockViewController") as? StatBlockViewController {
                vc.monster = appdelegate.monsterDataSource.getMonster(named: monsterName)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Group Name" }
        if section == 1 { return "Creatures In Group" }
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }

        return self.customGroup?.values?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfieldCell", for: indexPath)
            if let cell = cell as? TextFieldTableViewCell {
                cell.delegate = self
                cell.indexPath = indexPath
                cell.textfield.text = self.customGroup?.name
                cell.textfield.placeholder = "Enter custom group name..."
                cell.textfield.textColor = UIColor.fromHex(0x454545)
                cell.textfield.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.textLabel?.text = self.customGroup?.values?[indexPath.row]
            return cell
        }
    }
    
    // MARK: TextFieldCellDelegate
    
    func textFieldChanged(atIndexPath indexPath: IndexPath?, text: String?) {
        self.customGroup?.name = text
    }

    func textFieldTappedReturn() {
        
    }
    
    // MARK: AddEnemyDelegage
    
    func didTapMonster(_ monster: Monster) {
        self.navigationController?.popViewController(animated: true)
        
        var valueSet = Set(self.customGroup?.values ?? [])
        valueSet.insert(monster.name ?? "")
        self.customGroup?.values = Array(valueSet)
        
        self.tableview.reloadData()
    }
    

}
