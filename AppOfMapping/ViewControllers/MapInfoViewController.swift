//
//  MapInfoViewController
//  Slaad
//
//  Created by PJ Gray on 5/4/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol MapInfoDelegate {
    func didUpdateMapName(_ map: DungeonMap?)
}

class MapInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RoomDelegate, ButtonCellDelegate, DoubleButtonCellDelegate, EditStringDelegate {
    
    var map : DungeonMap?
    var delegate : MapInfoDelegate?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.title = "Map Information"
        
        self.tableview.rowHeight = UITableView.automaticDimension
        
        let recycle = UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: recycle, style: .plain, target: self, action: #selector(tappedRefresh))
    }
    
    @objc func tappedRefresh() {
        self.map?.generateEncounters(success: {
            if !(self.map?.nameLocked ?? false) {
                self.delegate?.didUpdateMapName(self.map)
            }
            self.map?.randomizeMapDescription()
            self.tableview.reloadData()
        }, failure: nil)
    }

    @objc func tappedHide() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "EditStringViewController") as? EditStringViewController {
                vc.indexPath = indexPath
                vc.string = self.map?.name
                vc.header = "Map Name"
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "EditStringViewController") as? EditStringViewController {
                vc.indexPath = indexPath
                vc.string = self.map?.dungeonDescription
                vc.header = "Map Description"
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "RoomViewController") as? RoomViewController {
                vc.room = map?.rooms[indexPath.row]
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    

    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Map Name"
        }
        
        if section == 1 {
            return "Map Description"
        }
        
        
        if section == 3 {
            return "Rooms"
        }
        
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let map = self.map else { fatalError("Map not found.") }
        if (section == 0) || (section == 1) || (section == 2) {
            return 1
        }

        return map.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locked = UIImage.fontAwesomeIcon(name: .lock, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20, height: 20))
        let unlocked = UIImage.fontAwesomeIcon(name: .lockOpen, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20, height: 20))

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doubleButtonCell", for: indexPath)
            if let cell = cell as? DoubleButtonCell {
                cell.accessoryType = .disclosureIndicator
                
                if self.map?.nameLocked ?? false {
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
                let image = (self.map?.nameLocked ?? false) ? locked : unlocked
                cell.rightButton.setImage(image, for: .normal)
                
                cell.leftButton.tintColor = UIColor.fromHex(0x454545)
                cell.leftButton.setTitle(nil, for: .normal)
                cell.leftButton.setImage(UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20, height: 20)), for: .normal)
                
                cell.label.numberOfLines = 0
                cell.label.text = self.map?.name ?? "Enter map name..."
                cell.label.textColor = self.map?.name != nil ? UIColor.fromHex(0x454545) : UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)

            if let cell = cell as? ButtonTableViewCell {
                cell.delegate = self
                cell.indexPath = indexPath
                cell.button.tintColor = UIColor.fromHex(0x454545)
                cell.button.setTitle(nil, for: .normal)
                cell.button.setImage(UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: UIColor.fromHex(0x454545), size: CGSize(width: 20, height: 20)), for: .normal)

                cell.accessoryType = .disclosureIndicator
                cell.titleLabel?.textColor = UIColor.fromHex(0x454545)
                cell.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
                cell.titleLabel?.text = self.map?.dungeonDescription
                cell.titleLabel?.numberOfLines = 0
            }
            
            return cell
        } else if indexPath.section == 2 {
            let totalAdjustedXP = self.map?.rooms.map({$0.encounter?.adjustedExperiencePoints(forPartySize: PartyDataSource.shared.party?.members.count ?? 0) ?? 0}).reduce(0,+)
            let days : Double = Double(totalAdjustedXP ?? 0) / Double(PartyDataSource.shared.party?.adjustedXPPerAdventuringDay() ?? 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)
            cell.textLabel?.textColor = UIColor.fromHex(0x454545)
            cell.textLabel?.text = "Required Rests"
            cell.detailTextLabel?.textColor = UIColor.fromHex(0x454545)
            let longRests = floor(days).description.dropLast(2).description
            
            let valDecimal = days.truncatingRemainder(dividingBy: 1)
            var shortRests : Int = 2 * Int(floor(days))
            if valDecimal > 0.6 {
                shortRests = shortRests + 2
            } else if valDecimal > 0.3 {
                shortRests = shortRests + 1
            }
            cell.detailTextLabel?.text = "\(longRests) long, \(shortRests) short"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        
        if let cell = cell as? ButtonTableViewCell {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.button.tintColor = UIColor.fromHex(0x454545)
            cell.button.setTitle(nil, for: .normal)
            let image = (self.map?.rooms[indexPath.row].roomLocked ?? false) ? locked : unlocked
            cell.button.setImage(image, for: .normal)

            cell.accessoryType = .disclosureIndicator
            cell.titleLabel?.textColor = UIColor.fromHex(0x454545)
            cell.titleLabel?.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: "\(indexPath.row + 1). ")
            if let room = self.map?.rooms[indexPath.row], let encounter = room.encounter, encounter.enemies.count > 0 {
                let name = room.name != nil ? "\(room.name ?? "")\n" : ""
                attrString.append(NSAttributedString(string: name, attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x454545),
                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
                    ]))
                attrString.append(NSAttributedString(string: "\(encounter.enemiesDescription())"))
                cell.titleLabel?.attributedText = attrString
            } else if self.map?.rooms[indexPath.row].trap != nil {
                attrString.append(NSAttributedString(string: "Trap"))
                cell.titleLabel?.attributedText = attrString
            } else {
                attrString.append(NSAttributedString(string: "(Empty)"))
                cell.titleLabel?.attributedText = attrString
            }
        }
        
        return cell
    }

    // MARK: EditStringDelegate
    
    func didEditString(_ indexPath: IndexPath?, _ text: String?) {
        if indexPath?.section == 0 {
            self.map?.name = text
            self.delegate?.didUpdateMapName(self.map)
        } else if indexPath?.section == 1 {
            self.map?.dungeonDescription = text
        }
        self.tableview.reloadData()
    }
    
    // MARK: RoomDelegate
    
    func didUpdateRoom(_ room: Room?) {
        if room?.encounter?.boss == true {
            self.map?.randomizeMapDescription()
        }
        self.tableview.reloadData()
    }
    
    // MARK: ButtonCellDelegate
    
    func buttonTapped(_ indexPath: IndexPath?) {
        if indexPath?.section == 1 {
            self.map?.randomizeMapDescription()
            self.tableview.reloadData()
        } else {
            if let indexPath = indexPath {
                self.map?.rooms[indexPath.row].roomLocked = !(self.map?.rooms[indexPath.row].roomLocked ?? false)
                self.tableview.reloadData()
            }
        }
    }
    
    // MARK: DoubleButtonCellDelegate
    
    func leftButtonTapped(_ indexPath: IndexPath?) {
        self.map?.name = self.map?.getRandomMapName()
        self.delegate?.didUpdateMapName(self.map)
        self.tableview.reloadData()
    }
    
    func rightButtonTapped(_ indexPath: IndexPath?) {
        self.map?.nameLocked = !(self.map?.nameLocked ?? false)
        self.tableview.reloadData()
    }
    

}
