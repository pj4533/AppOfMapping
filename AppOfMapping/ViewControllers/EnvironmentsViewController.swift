//
//  EnvironmentsViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/8/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

class EnvironmentsViewController: UIViewController {//, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Environments"
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
//        if indexPath.row == 0 {
//            appdelegate.monsterDataSource.setEnvironmentFilter([])
//        } else {
//            let environments = appdelegate.monsterDataSource.getSupportedEnvironments()
//            let environment = environments[indexPath.row - 1]
//
//            if appdelegate.monsterDataSource.getEnvironmentFilter().contains(environment) {
//                appdelegate.monsterDataSource.removeEnvironmentFilter(environment)
//            } else {
//                appdelegate.monsterDataSource.addEnvironmentFilter(environment)
//            }
//        }
//        self.tableview.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
//
//        return appdelegate.monsterDataSource.getSupportedEnvironments().count + 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
//        cell.textLabel?.textColor = UIColor.fromHex(0x454545)
//
//        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
//        let environments = appdelegate.monsterDataSource.getSupportedEnvironments()
//        let environmentFilter = appdelegate.monsterDataSource.getEnvironmentFilter()
//        cell.accessoryType = .none
//
//        if indexPath.row == 0 {
//            if environmentFilter.isEmpty {
//                cell.accessoryType = .checkmark
//            }
//            cell.textLabel?.text = "All"
//        } else {
//            let environment = environments[indexPath.row - 1]
//
//            cell.textLabel?.text = environment.rawValue
//
//            if environmentFilter.contains(environment) {
//                cell.accessoryType = .checkmark
//            }
//        }
//
//        return cell
//    }
    
}
