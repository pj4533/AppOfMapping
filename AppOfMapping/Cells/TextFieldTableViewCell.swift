//
//  TextFieldTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/14/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate {
    func textFieldChanged(atIndexPath indexPath: IndexPath?, text: String?)
    func textFieldTappedReturn()
}

protocol TextFieldButtonCellDelegate : TextFieldCellDelegate {
    func buttonTapped(_ indexPath: IndexPath?)
}

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    var indexPath : IndexPath?
    var delegate : TextFieldCellDelegate?
    var numberOnly : Bool = false
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonSpacerConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textfield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textfield.delegate = self
        self.textfield.returnKeyType = .done
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func textFieldValueChanged(_ sender: Any) {
        self.delegate?.textFieldChanged(atIndexPath: self.indexPath, text: self.textfield.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldTappedReturn()
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.numberOnly {
            let allowedCharacters = CharacterSet.decimalDigits.union (CharacterSet (charactersIn: "."))  
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if let delegate = self.delegate as? TextFieldButtonCellDelegate {
            delegate.buttonTapped(indexPath)
        }
        
    }
}
