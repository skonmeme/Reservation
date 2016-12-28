//
//  ReservationDatePickerTableViewCell.swift
//  Reservation
//
//  Created by Sung Gon Yi on 23/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit

class ReservationDatePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
