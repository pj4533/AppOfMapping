//
//  TaperedLineTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/21/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

class TaperedLineTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width - 21.0, y: self.frame.size.height / 2.0))
        path.addLine(to: CGPoint(x: 21.0, y: self.frame.size.height-8.0))
        path.addLine(to: CGPoint(x: 21.0, y: 8.0))
        path.close()
        
        UIColor.fromHex(0x7A200D).setFill()
        path.fill()
        UIColor.fromHex(0x7A200D).setStroke()
        path.stroke()
    }
}
