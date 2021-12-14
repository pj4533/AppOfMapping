//
//  PickerTableViewCell.swift
//  Slaad
//
//  Created by PJ Gray on 5/10/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

// this is reall specific to picking a level (integers), if I need a different picker cell, then subclass this

protocol PickerCellDelegate {
    func selectedRow(_ row:Int, indexPath: IndexPath?)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate : PickerCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: UIPickerDataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: UIPickerDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.selectedRow(row, indexPath: self.indexPath)
    }

}
