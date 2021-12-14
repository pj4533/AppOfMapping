//
//  SettingsViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/4/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit
import SpriteKit
import MobileCoreServices
import SVProgressHUD

protocol SettingsDelegate {
    func didUpdateMap(_ map: DungeonMap?)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate, PickerCellDelegate {

    var delegate : SettingsDelegate?
    var map : DungeonMap?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.title = "Settings"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableview.reloadData()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "PartyViewController") as? PartyViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let map = self.map {
                    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
                    let filename = "\(map.name ?? "map").json"
                    let filePath = (documentsDirectory as NSString).appendingPathComponent(filename) as String
                    
                    let encoder =  JSONEncoder()
                    do {
                        let jsonData = try encoder.encode(map)
                        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                            try jsonString.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
                            let documentPicker = UIDocumentPickerViewController(url: URL(fileURLWithPath: filePath), in: .exportToService)
                            documentPicker.delegate = self
                            self.present(documentPicker, animated: true)
                        }
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                }
                
            } else if indexPath.row == 1 {
                let alert = UIAlertController(title: nil, message: "Replace this map?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
                    documentPicker.view.tag = 1
                    documentPicker.delegate = self
                    self.present(documentPicker, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
                documentPicker.delegate = self
                documentPicker.view.tag = 2
                self.present(documentPicker, animated: true)
            } else {
                UserDefaults.standard.removeObject(forKey: "XMLData")
                UserDefaults.standard.synchronize()
                guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
                appdelegate.monsterDataSource = SRDMonsterDataSource.shared

                let alert = UIAlertController(title: nil, message: "Reverted to SRD data only.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                }))
                self.present(alert, animated: true, completion: nil)

                tableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 1 {
            return 88
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Configuration"
        } else if section == 1 {
            return "Tools"
        } else if section == 2 {
            return "Advanced"
        }
        
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            if UserDefaults.standard.object(forKey: "XMLData") == nil {
                return 1
            } else {
                return 2
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerTableViewCell else { fatalError("error") }
                cell.pickerLabel?.textColor = UIColor.fromHex(0x454545)
                cell.pickerLabel?.text = "Max number of rooms"
                cell.indexPath = indexPath
                cell.delegate = self
                cell.pickerView.selectRow(UserDefaults.standard.integer(forKey: "maxNumberRooms") - 1, inComponent: 0, animated: false)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.detailTextLabel?.textColor = UIColor.fromHex(0xa7a7a7)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            
            cell.accessoryType = .disclosureIndicator

            if indexPath.row == 0 {
                cell.textLabel?.text = "Party"
                cell.detailTextLabel?.text = "\(PartyDataSource.shared.party?.members.count ?? 0) members"
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.imageView?.image = nil
            cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            cell.accessoryType = .none

            if indexPath.row == 0 {
                cell.textLabel?.text = "Export Map Data"
            } else {
                cell.textLabel?.text = "Import Map Data"
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Import XML Creature(s)"
            } else {
                cell.textLabel?.text = "Use SRD Only"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            cell.textLabel?.text = "The data used in this app is Open Game Content, licensed for public use by the Open Game License 1.0a Copyright 2000, Wizards of the Coast, LLC.  Click to view license in full"
            return cell
        }
        
    }

    // MARK: UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            if controller.documentPickerMode == .import {
                do {
                    if controller.view.tag == 1 {
                        let data = try Data(contentsOf: url)
                        let decoder  = JSONDecoder()
                        self.map = try decoder.decode(DungeonMap.self, from: data)
                        self.delegate?.didUpdateMap(self.map)
                        self.dismiss(animated: true, completion: nil)
                        self.tableview.reloadData()
                    } else if controller.view.tag == 2 {
                        let data = try Data(contentsOf: url)
                        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
                        if let existingDataSource = appdelegate.monsterDataSource as? GM5MonsterDataSource {
                            let additionalCount = try existingDataSource.addMonstersFromData(data)
                            existingDataSource.persistAllData()
                            let alert = UIAlertController(title: nil, message: "Imported \(additionalCount) creature(s).", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let datasource = try GM5MonsterDataSource(dataArray: [data])
                            datasource.persistAllData()
                            appdelegate.monsterDataSource = datasource
                            let alert = UIAlertController(title: nil, message: "Using XML with \(appdelegate.monsterDataSource.allMonsters.count) creatures.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.tableview.reloadData()
                    }
                } catch let error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Done!", message: "Map exported successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: PickerCellDelegate
    
    func selectedRow(_ row: Int, indexPath: IndexPath?) {
        UserDefaults.standard.set(row + 1, forKey: "maxNumberRooms")
        UserDefaults.standard.synchronize()
    }
    

}
