//
//  SwitchTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 6/3/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func switchValueChanged(_ indexPath: IndexPath?, _ value: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    var delegate: SwitchCellDelegate?
    var indexPath : IndexPath?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        self.delegate?.switchValueChanged(self.indexPath, self.switchControl.isOn)
    }
}
