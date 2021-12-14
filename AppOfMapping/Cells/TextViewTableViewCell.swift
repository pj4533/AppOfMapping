//
//  TextViewTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/16/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol TextViewCellDelegate {
    func textViewDidChange(atIndexPath indexPath:IndexPath?, _ text:String?)
}

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    var delegate : TextViewCellDelegate?
    var indexPath : IndexPath?
    
    @IBOutlet weak var textview: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textview.delegate = self
        self.textview.textColor = UIColor.fromHex(0x454545)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: TextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textViewDidChange(atIndexPath: self.indexPath, textview.text)
    }
}
