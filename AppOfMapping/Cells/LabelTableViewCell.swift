//
//  LabelTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/21/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var customLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
