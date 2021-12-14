//
//  StatsTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/21/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var strValueLabel: UILabel!
    @IBOutlet weak var dexLabel: UILabel!
    @IBOutlet weak var dexValueLabel: UILabel!
    @IBOutlet weak var conLabel: UILabel!
    @IBOutlet weak var conValueLabel: UILabel!
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var intValueLabel: UILabel!
    @IBOutlet weak var wisLabel: UILabel!
    @IBOutlet weak var wisValueLabel: UILabel!
    @IBOutlet weak var chaLabel: UILabel!
    @IBOutlet weak var chaValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
