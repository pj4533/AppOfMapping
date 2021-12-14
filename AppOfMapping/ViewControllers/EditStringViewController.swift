//
//  EditStringViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/16/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol EditStringDelegate {
    func didEditString(_ indexPath: IndexPath?, _ text: String?)
}

class EditStringViewController: UIViewController, TextViewCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var delegate : EditStringDelegate?
    var string : String?
    var header : String?
    var indexPath : IndexPath?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textviewCell", for: indexPath)
        
        if let cell = cell as? TextViewTableViewCell {
            cell.indexPath = indexPath
            cell.delegate = self
            
            cell.textview.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            cell.textview.text = self.string

            cell.textview.becomeFirstResponder()
        }
        return cell
    }

    // MARK: TextViewCellDelegate
    
    func textViewDidChange(atIndexPath indexPath: IndexPath?, _ text: String?) {
        self.delegate?.didEditString(self.indexPath, text)
    }
}
