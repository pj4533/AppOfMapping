//
//  ButtonTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/9/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate {
    func buttonTapped(_ indexPath: IndexPath?)
}
class ButtonTableViewCell: UITableViewCell {
    var delegate: ButtonCellDelegate?
    var indexPath : IndexPath?
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.buttonTapped(indexPath)
    }
}
