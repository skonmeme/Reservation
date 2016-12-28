//
//  ReservationDateTableViewCell.swift
//  Reservation
//
//  Created by Sung Gon Yi on 23/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit

class ReservationDateTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dateLabel.text = DateFormatter().string(from: Date())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
