//
//  EditEnemyViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/14/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol EditEnemyDelegate {
    func didEditEnemy()
}

class EditEnemyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TextFieldCellDelegate {

    var enemy : EncounterEnemy?
    var delegate : EditEnemyDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.title = "Edit Enemy"
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Edit Name"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textfieldCell", for: indexPath)
        if let cell = cell as? TextFieldTableViewCell {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.textfield.text = self.enemy?.label
            cell.textfield.textColor = UIColor.fromHex(0x454545)
            cell.textfield.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        }
        
        return cell
    }
    
    // MARK: TextFieldCellDelegate
    
    func textFieldChanged(atIndexPath indexPath: IndexPath?, text: String?) {
        self.enemy?.label = text
        self.enemy?.locked = true
        self.delegate?.didEditEnemy()
    }
    
    func textFieldTappedReturn() {
        
    }
}
