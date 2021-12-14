//
//  PartyViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/5/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit
import SVProgressHUD

class PartyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlayerCharacterDelegate, TextFieldCellDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Party"
        self.updateNavBar()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.tableView.contentInset = .zero
        } else {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        
    }
    
    func updateNavBar() {
        if (PartyDataSource.shared.party?.members.filter({$0.externalLink != nil}).count ?? 0) > 0 {
            let recycle = UIImage.fontAwesomeIcon(name: .redoAlt, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:#selector(editTapped(_:))),
                UIBarButtonItem(image: recycle, style: .plain, target: self, action: #selector(tappedRefresh))
            ]
        } else {
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:#selector(editTapped(_:)))
        }
    }
    
    func update() {
        self.updateNavBar()
        self.tableView.reloadData()
    }
    
    @objc func tappedRefresh() {
        SVProgressHUD.show()
        PartyDataSource.shared.refreshParty(success: {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.update()
            }
        }, failure: nil)
    }

    @IBAction func addTapped(_ sender: Any) {
        let controller = UIAlertController(title: "Add New Character", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            controller.dismiss(animated: true, completion:nil)
        })
        controller.addAction(cancelAction)
        
        controller.addAction(UIAlertAction(title: "Configure By Hand", style: .default, handler: { (action) in
            PartyDataSource.shared.addDefaultMember()
            self.update()
        }))
        controller.addAction(UIAlertAction(title: "Import From D&D Beyond", style: .default, handler: { (action) in
            var message = ""
            if UserDefaults.standard.object(forKey: "DNDBeyondLogin") == nil {
                message = "(Requires Login)"
            }
            let alertController = UIAlertController(title: "Add From D&D Beyond", message: message, preferredStyle: UIAlertController.Style.alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Link To Character"
            }
            let saveAction = UIAlertAction(title: "Import", style: UIAlertAction.Style.default, handler: { alert -> Void in
                if let linkTextField = alertController.textFields?[0], let url = URL(string: "\((linkTextField.text ?? "") + "/json")") {
                    let datasource = DNDBeyondDataSource()
                    SVProgressHUD.show()
                    datasource.getCharacter(with: url, success: { (pc) in
                        PartyDataSource.shared.addMember(pc)
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.update()
                        }
                    }) { (error) in
                        print(error ?? "Some error that we know nothing about")
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Link not valid", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in })
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }))
        
        // Use the popover presentation style for your view controller.
        controller.modalPresentationStyle = .popover
        
        // Specify the anchor point for the popover.
        controller.popoverPresentationController?.barButtonItem = self.addButton
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: self.tableView.isEditing ? .done : .edit, target: self, action: #selector(self.editTapped(_:)))
    }
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PlayerCharacterViewController") as? PlayerCharacterViewController {
            vc.playerCharacter = PartyDataSource.shared.party?.members[indexPath.row]
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        if section == 1 {
            return "Elite Party Factor"
        }
        
        return "Boss Max CR"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        if section == 1 {
            return "Elite party factor will multiply the adjusted XP budget per encounter."
        }
        
        return "Boss max CR will set elite party factor to match a desired max CR."
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return PartyDataSource.shared.party?.members.count ?? 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
            
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            
            if let pc = PartyDataSource.shared.party?.members[indexPath.row] {
                cell.textLabel?.text = "Level: \(pc.totalLevel())"
                cell.detailTextLabel?.text = pc.name ?? "<unnamed>"
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfieldCell", for: indexPath)
            if let cell = cell as? TextFieldTableViewCell {
                cell.textfield.text = "\(PartyDataSource.shared.party?.elitePartyFactor ?? 1.0)"
                cell.textfield.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
                cell.textfield.textColor = UIColor.fromHex(0x454545)
                cell.numberOnly = true
                cell.indexPath = indexPath
                cell.delegate = self
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfieldCell", for: indexPath)
            if let cell = cell as? TextFieldTableViewCell {
                cell.textfield.text = "\(Monster.highestCRUnderXPBudget(PartyDataSource.shared.party?.xpThreshhold(withEncounterDifficulty: .deadly) ?? 0))"
                cell.textfield.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
                cell.textfield.textColor = UIColor.fromHex(0x454545)
                cell.indexPath = indexPath
                cell.delegate = self
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PartyDataSource.shared.removeMember(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.update()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: PlayerCharacterDelegate
    
    func updatedPlayerCharacter() {
        self.update()
        PartyDataSource.shared.saveParty()
    }
    
    // MARK: TextFieldCellDelegate
    
    func textFieldChanged(atIndexPath indexPath: IndexPath?, text: String?) {
        if indexPath?.section == 1 {
            let elite = Double(text ?? "0") ?? 0.0
            PartyDataSource.shared.party?.elitePartyFactor = elite > 0.0 ? elite : 1.0
            PartyDataSource.shared.saveParty()
        } else {
            if (text?.count ?? 0) > 0 {
                let budgetByCR = Monster.xpBudgetByCR(text ?? "1/4")
                let rawBudget = Int(Double(PartyDataSource.shared.party?.members.map({$0.xpThreshhold(withEncounterDifficulty: .deadly)}).reduce(0, +) ?? 0))
                
                PartyDataSource.shared.party?.elitePartyFactor = Double(budgetByCR) / Double(rawBudget)
                PartyDataSource.shared.saveParty()
            }
        }
        
    }

    func textFieldTappedReturn() {
        self.tableView.reloadData()
    }
}
