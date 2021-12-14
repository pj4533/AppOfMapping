//
//  DoubleButtonCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/25/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol DoubleButtonCellDelegate {
    func leftButtonTapped(_ indexPath: IndexPath?)
    func rightButtonTapped(_ indexPath: IndexPath?)
}

class DoubleButtonCell: UITableViewCell {
    var delegate: DoubleButtonCellDelegate?
    var indexPath : IndexPath?

    @IBOutlet weak var leftButtonSpacerConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func rightButtonTapped(_ sender: Any) {
        self.delegate?.rightButtonTapped(self.indexPath)
    }
    @IBAction func leftButtonTapped(_ sender: Any) {
        self.delegate?.leftButtonTapped(self.indexPath)
    }
}
