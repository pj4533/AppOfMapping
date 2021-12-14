//
//  PlayerCharacterViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/10/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol PlayerCharacterDelegate {
    func updatedPlayerCharacter()
}

class PlayerCharacterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PickerCellDelegate, EditStringDelegate {

    var delegate : PlayerCharacterDelegate?
    var playerCharacter : PlayerCharacter?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.playerCharacter?.externalLink != nil {
            let recycle = UIImage.fontAwesomeIcon(name: .redoAlt, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: recycle, style: .plain, target: self, action: #selector(tappedRefresh))
        }
    }
    
    @objc func tappedRefresh() {
        SVProgressHUD.show()
        PartyDataSource.shared.refreshPartyMember(playerCharacter, success: { (pc) in
            self.playerCharacter = pc
            self.delegate?.updatedPlayerCharacter()
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }, failure: nil)
    }

    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // only editing of internal characters
        if self.playerCharacter?.externalLink == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "EditStringViewController") as? EditStringViewController {
                if indexPath.section == 0 {
                    vc.string = self.playerCharacter?.name
                    vc.header = "Character Name"
                } else {
                    vc.string = self.playerCharacter?.classes?[indexPath.row].definition?.name
                    vc.header = "Class Name"
                }
                vc.indexPath = indexPath
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Classes"
        }
        
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return self.playerCharacter?.classes?.count ?? 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if (indexPath.row == 0) && (self.playerCharacter?.externalLink == nil) {
                return 88.0
            }
        }
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.textLabel?.text = self.playerCharacter?.name ?? "Unnamed"
            return cell
        } else {
            let thisClass = self.playerCharacter?.classes?[indexPath.row]

            // only editing of internal characters
            if self.playerCharacter?.externalLink == nil {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerTableViewCell else { fatalError("error") }
                cell.pickerLabel?.textColor = UIColor.fromHex(0x454545)
                cell.pickerLabel?.text = thisClass?.definition?.name ?? "Unknown Class"
                cell.indexPath = indexPath
                cell.delegate = self
                cell.pickerView.selectRow((thisClass?.level ?? 1) - 1, inComponent: 0, animated: false)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetailCell", for: indexPath)
                cell.textLabel?.textColor = UIColor.fromHex(0x454545)
                cell.textLabel?.text = thisClass?.definition?.name ?? "Unknown Class"
                cell.detailTextLabel?.text = "\(thisClass?.level ?? 0)"
                return cell
            }
        }
    }
    
    // MARK: PickerCellDelegate
    
    func selectedRow(_ row: Int, indexPath: IndexPath?) {
        guard let indexPath = indexPath else { fatalError("index path not set") }
        if (indexPath.section == 1) {
            self.playerCharacter?.classes?[indexPath.row].level = row + 1
        }
        
        self.delegate?.updatedPlayerCharacter()
    }
    
    // MARK: EditStringDelegate
    
    func didEditString(_ indexPath: IndexPath?, _ text: String?) {
        if indexPath?.section == 0 {
            self.playerCharacter?.name = text
        } else {
            if let indexPath = indexPath {
                if self.playerCharacter?.classes?[indexPath.row].definition == nil {
                    let definition = ClassDefinition()
                    definition.name = text
                    self.playerCharacter?.classes?[indexPath.row].definition = definition
                } else {
                    self.playerCharacter?.classes?[indexPath.row].definition?.name = text
                }
            }
        }
        self.tableView.reloadData()
        self.delegate?.updatedPlayerCharacter()
    }
}
