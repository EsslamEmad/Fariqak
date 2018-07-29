//
//  ReservationTableViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 15/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {

    @IBOutlet var reservationImageView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var reserverButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
