//
//  RoomViewController
//  Slaad
//
//  Created by PJ Gray on 5/9/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit
import MobileCoreServices
import SVProgressHUD

protocol RoomDelegate {
    func didUpdateRoom(_ room: Room?)
}

class RoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddEnemyDelegate, ButtonCellDelegate, EditEnemyDelegate, UIDocumentPickerDelegate, DoubleButtonCellDelegate, EditStringDelegate, SwitchCellDelegate {
    var delegate : RoomDelegate?
    var room : Room?
    var editButton: UIBarButtonItem!

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    
    var isModal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        if let roomId = self.room?.roomId { self.title = "Room \(roomId)" }
        let recycle = UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
        self.editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:#selector(editTapped(_:)))
        self.navigationItem.rightBarButtonItems = [
            editButton,
            UIBarButtonItem(image: recycle, style: .plain, target: self, action: #selector(tappedRefresh))
        ]
        
        self.updateUI()
    }
    
    func updateUI() {
        if self.room?.encounter != nil {
            self.addButton.isEnabled = true
            self.actionButton.isEnabled = true
            self.editButton.isEnabled = true
        } else {
            self.addButton.isEnabled = false
            self.actionButton.isEnabled = false
            self.editButton.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.isModal {
            let times = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: times, style: .plain, target: self, action: #selector(tappedHide))
        }
    }
    
    @objc func tappedHide() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedRefresh() {
        if let party = PartyDataSource.shared.party {
            let datasource = RoomDataSource()
            datasource.randomize(self.room, for: party, success: {
                self.updateUI()
                self.tableview.reloadData()
                self.delegate?.didUpdateRoom(self.room)
            }) { (error) in
                let controller = UIAlertController(title: "Error", message: "Constraints too strict, try removing some locks.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

    @IBAction func tappedAction(_ sender: Any) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            controller.dismiss(animated: true, completion:nil)
        })
        controller.addAction(cancelAction)
        
        controller.addAction(UIAlertAction(title: "Export Encounter", style: .default, handler: { (action) in
            if let encounter = self.room?.encounter {
                let documentsDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
                let filename = "\(self.room?.name ?? "room").json"
                let filePath = (documentsDirectory as NSString).appendingPathComponent(filename) as String
                
                let encoder =  JSONEncoder()
                do {
                    let jsonData = try encoder.encode(encounter)
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
        }))
        controller.addAction(UIAlertAction(title: "Import Encounter", style: .default, handler: { (action) in
            let alert = UIAlertController(title: nil, message: "Replace this encounter?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
                documentPicker.delegate = self
                self.present(documentPicker, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }))
        
        // Use the popover presentation style for your view controller.
        controller.modalPresentationStyle = .popover
        
        // Specify the anchor point for the popover.
        controller.popoverPresentationController?.barButtonItem = self.actionButton
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func tappedAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddEnemyViewController") as? AddEnemyViewController {
            vc.delegate = self
            vc.title = "Add Enemy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.tableview.setEditing(!self.tableview.isEditing, animated: true)
        let recycle = UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: self.tableview.isEditing ? .done : .edit, target: self, action:#selector(editTapped(_:))),
            UIBarButtonItem(image: recycle, style: .plain, target: self, action: #selector(tappedRefresh))
        ]
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "EditStringViewController") as? EditStringViewController {
                vc.string = self.room?.name
                vc.header = "Room Name"
                vc.indexPath = indexPath
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "EditStringViewController") as? EditStringViewController {
                vc.string = self.room?.notes
                vc.header = "Room Notes"
                vc.indexPath = indexPath
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 2 {
            if self.room?.trap != nil {
                let datasource = TrapDataSource()
                datasource.getRandomTrap(success: { (trap) in
                    self.room?.trap = trap
                    self.tableview.reloadData()
                }, failure: nil)
            }
        } else if indexPath.section == 3 {
            self.room?.encounter?.difficultyLocked = !(self.room?.encounter?.difficultyLocked ?? false)
        } else if indexPath.section == 4 {
            let controller = UIAlertController(title: "\(self.room?.encounter?.enemies[indexPath.row].monster?.name ?? "")", message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                controller.dismiss(animated: true, completion:nil)
            })
            controller.addAction(cancelAction)
            
            controller.addAction(UIAlertAction(title: "View Stat Block", style: .default, handler: { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "StatBlockViewController") as? StatBlockViewController {
                    vc.monster = self.room?.encounter?.enemies[indexPath.row].monster
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }))
            controller.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "EditEnemyViewController") as? EditEnemyViewController {
                    vc.enemy = self.room?.encounter?.enemies[indexPath.row]
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }))
            controller.addAction(UIAlertAction(title: "Add Another", style: .default, handler: { (action) in
                if let monster = self.room?.encounter?.enemies[indexPath.row].monster {
                    let newEnemy = EncounterEnemy(monster: monster)
                    self.room?.encounter?.addEnemy(newEnemy)
                    self.tableview.reloadData()
                }
            }))
            
            // Use the popover presentation style for your view controller.
            controller.modalPresentationStyle = .popover
            
            // Specify the anchor point for the popover.
            controller.popoverPresentationController?.sourceView = self.tableview.cellForRow(at: indexPath)
            let rect = tableview.frame
            controller.popoverPresentationController?.sourceRect = CGRect(x: rect.width / 2.0, y: 20.0, width: 2, height: 2)
            
            self.present(controller, animated: true, completion: nil)
        } else if indexPath.section == 5 {
            self.room?.encounter?.generateTreasure()
        }
        self.tableview.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 4 { return true }
        
        return false
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 4 {
            var actions : [UITableViewRowAction] = []
            
            actions.append(UITableViewRowAction(style: .normal, title: "Add Another", handler: { (action, indexPath) in
                if let monster = self.room?.encounter?.enemies[indexPath.row].monster {
                    let newEnemy = EncounterEnemy(monster: monster)
                    self.room?.encounter?.addEnemy(newEnemy)
                    self.tableview.reloadData()
                }
            }))
            actions.append(UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
                self.room?.encounter?.removeEnemy(indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.delegate?.didUpdateRoom(self.room)
                self.tableview.reloadData()
            }))
            
            return actions
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let party = PartyDataSource.shared.party else { fatalError("Party Not Set")}

        if section == 6 {
            return """
            Easy: \(party.xpThreshhold(withEncounterDifficulty: .easy))
            Medium: \(party.xpThreshhold(withEncounterDifficulty: .medium))
            Hard: \(party.xpThreshhold(withEncounterDifficulty: .hard))
            Deadly: \(party.xpThreshhold(withEncounterDifficulty: .deadly))
            """
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Room Name"
        } else if section == 1 {
            return "Room Notes"
        } else if section == 2 {
            if self.room?.trap != nil {
                return "Trap"
            }
        } else if section == 3 {
            return "Encounter Difficulty"
        } else if section == 4 {
            return "Enemies"
        } else if section == 5 {
            return self.room?.encounter?.boss == true ? "Treasure Hoard" : "Treasure"
        } else if section == 6 {
            return "Experience"
        }

        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.room?.trap != nil {
            return 3
        }
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        if section == 1 {
            return 1
        }

        if section == 2 {
            return 1
        }

        if section == 3 {
            return 1
        }

        if section == 4 {
            return self.room?.encounter?.enemies.count ?? 0
        }

        if section == 5 {
            return 1
        }

        if section == 6 {
            return 3
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let party = PartyDataSource.shared.party else { fatalError("Party Not Set")}

        let locked = UIImage.fontAwesomeIcon(name: .lock, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20, height: 20))
        let unlocked = UIImage.fontAwesomeIcon(name: .lockOpen, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20, height: 20))
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doubleButtonCell", for: indexPath)
            if let cell = cell as? DoubleButtonCell {
                cell.accessoryType = .disclosureIndicator

                if self.room?.nameLocked ?? false {
                    cell.leftButtonConstraint.constant = 0.0
                    cell.leftButtonSpacerConstraint.constant = 0.0
                } else {
                    cell.leftButtonConstraint.constant = 30.0
                    cell.leftButtonSpacerConstraint.constant = 2.0
                }
                cell.delegate = self
                cell.indexPath = indexPath
                cell.rightButton.tintColor = UIColor.fromHex(0x454545)
                cell.rightButton.setTitle(nil, for: .normal)
                let image = (self.room?.nameLocked ?? false) ? locked : unlocked
                cell.rightButton.setImage(image, for: .normal)

                cell.leftButton.tintColor = UIColor.fromHex(0x454545)
                cell.leftButton.setTitle(nil, for: .normal)
                cell.leftButton.setImage(UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20, height: 20)), for: .normal)

                cell.label.numberOfLines = 0
                cell.label.text = self.room?.name ?? "Enter room name..."
                cell.label.textColor = self.room?.name != nil ? UIColor.fromHex(0x454545) : UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = self.room?.notes ?? "Enter room notes..."
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = self.room?.notes != nil ? UIColor.fromHex(0x454545) : UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
            return cell
        } else if indexPath.section == 2 {
            if self.room?.trap != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.imageView?.image = UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20.0, height: 20.0))
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "Trigger: \(self.room?.trap?.trigger ?? "")\n\nEffects: \(self.room?.trap?.effects ?? "")\n\nDetect/Disable/Save DC: \(self.room?.trap?.saveDC ?? 0)\nAttack: +\(self.room?.trap?.attackBonus ?? 0)\nDamage: \(self.room?.trap?.damageDice(party.members.first?.totalLevel() ?? 1) ?? "")"
                cell.textLabel?.textColor = UIColor.fromHex(0x454545)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath)
                cell.accessoryType = .none
                if let cell = cell as? SwitchTableViewCell {
                    cell.titleLabel.text = "Is Boss Encounter?"
                    cell.titleLabel?.textColor = UIColor.fromHex(0x454545)
                    cell.switchControl.isOn = self.room?.encounter?.boss ?? false
                    cell.delegate = self
                    cell.indexPath = indexPath
                }
                return cell
            }
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)
            cell.imageView?.image = (self.room?.encounter?.difficultyLocked ?? false) ? locked : unlocked
            cell.detailTextLabel?.text = nil
            cell.textLabel?.text = "\(self.room?.encounter?.difficultyForParty(PartyDataSource.shared.party).rawValue ?? "")"
            
            if self.room?.encounter?.difficultyForParty(PartyDataSource.shared.party) == .deadly {
                let deadlyValue = Int((self.room?.encounter?.adjustedExperiencePoints(forPartySize: party.members.count) ?? 0) / (party.xpThreshhold(withEncounterDifficulty: .deadly)))
                if deadlyValue > 1 {
                    cell.textLabel?.text = "\(cell.textLabel?.text ?? "") x \(deadlyValue)"
                }
            }
            
            cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
            if let cell = cell as? ButtonTableViewCell {
                let enemy = self.room?.encounter?.enemies[indexPath.row]
                cell.titleLabel?.text = enemy?.label
                cell.titleLabel?.textColor = UIColor.fromHex(0x454545)
                cell.subtitleLabel?.text = "CR \(enemy?.monster?.challengeRating ?? "")"
                cell.subtitleLabel?.textColor = UIColor.fromHex(0xa7a7a7)
                cell.subtitleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

                cell.delegate = self
                cell.indexPath = indexPath
                cell.button.tintColor = UIColor.fromHex(0x454545)
                cell.button.setTitle(nil, for: .normal)
                let image = (enemy?.locked ?? false) ? locked : unlocked
                cell.button.setImage(image, for: .normal)
                
                cell.accessoryType = .disclosureIndicator
            }

            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
            cell.imageView?.image = UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20.0, height: 20.0))
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = self.room?.encounter?.treasureDescription()
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.detailTextLabel?.text = "\(self.room?.encounter?.boss == true ? "Total Value (Coins/Gems/Art):" : "Total Value:") \(Treasure.totalGPValue(self.room?.encounter?.treasure())) gp"
            cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
            cell.imageView?.image = nil
            if indexPath.row == 0 {
                cell.textLabel?.text = "Actual Experience"
                cell.detailTextLabel?.text = "\(self.room?.encounter?.experiencePoints() ?? 0)"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Adjusted Experience"
                cell.detailTextLabel?.text = "\(self.room?.encounter?.adjustedExperiencePoints(forPartySize: party.members.count) ?? 0)"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Experience Per Party Member"
                cell.detailTextLabel?.text = "\(Int((self.room?.encounter?.experiencePoints() ?? 0) / party.members.count))"
            }
            return cell
        }
    }
    
    // MARK: AddEnemyDelegage
    
    func didTapMonster(_ monster: Monster) {
        self.navigationController?.popViewController(animated: true)
        
        let enemy = EncounterEnemy(monster: monster)
        self.room?.encounter?.addEnemy(enemy)
        self.tableview.reloadData()
        
        self.delegate?.didUpdateRoom(self.room)
    }
    
    // MARK: ButtonCellDelegate
    
    func buttonTapped(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            if indexPath.section == 0 {
                self.room?.nameLocked = !(self.room?.nameLocked ?? false)
            } else if indexPath.section == 2 {
                // boss room switch
            } else if indexPath.section == 4 {
                self.room?.encounter?.enemies[indexPath.row].locked = !(self.room?.encounter?.enemies[indexPath.row].locked ?? false)
                if !(self.room?.roomLocked ?? false) {
                    self.room?.roomLocked = true
                    self.delegate?.didUpdateRoom(self.room)
                }
            }
            self.tableview.reloadData()
        }
    }
    
    // MARK: EditEnemyDelegate
    
    func didEditEnemy() {
        self.tableview.reloadData()
        self.delegate?.didUpdateRoom(self.room)
    }
    
    // MARK: UIDocumentPickerDelegate

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == .exportToService {
            let alert = UIAlertController(title: "Done!", message: "Encounter exported successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let url = urls.first {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder  = JSONDecoder()
                    self.room?.encounter = try decoder.decode(Encounter.self, from: data)
                    self.tableview.reloadData()
                    self.delegate?.didUpdateRoom(self.room)
                } catch let error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: DoubleButtonCellDelegate
    
    func leftButtonTapped(_ indexPath: IndexPath?) {
        let datasource = EncounterDataSource()
        self.room?.name = datasource.getRandomRoomName(forEncounter: self.room?.encounter)
        self.delegate?.didUpdateRoom(self.room)
        self.tableview.reloadData()
    }
    
    func rightButtonTapped(_ indexPath: IndexPath?) {
        self.room?.nameLocked = !(self.room?.nameLocked ?? false)
        self.tableview.reloadData()
    }
    
    // MARK: EditStringDElegate
    
    func didEditString(_ indexPath: IndexPath?, _ text: String?) {
        if indexPath?.section == 0 {
            self.room?.name = text
        } else {
            self.room?.notes = text
        }
        self.tableview.reloadData()
        self.delegate?.didUpdateRoom(self.room)
    }
    
    // MARK: SwitchCellDelegate
    
    func switchValueChanged(_ indexPath: IndexPath?, _ value: Bool) {
        var message = "Regenerate encounter as boss?"
        if !value {
            message = "Regenerate encounter as non-boss?"
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            if let party = PartyDataSource.shared.party {
                let datasource = EncounterDataSource()
                if value {
                    datasource.getBossEncounter(for: party, success: { (encounter) in
                        self.room?.encounter = encounter
                        self.tableview.reloadData()
                    }, failure: nil)
                } else {
                    datasource.getEncounter(for: party, maxEnemies: 3, success: { (encounter) in
                        self.room?.encounter = encounter
                        self.room?.name = nil
                        self.tableview.reloadData()
                    }, failure: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler:  { (action) in
            self.tableview.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
