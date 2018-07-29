//
//  OrderTableViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 9/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet var orderNumberLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
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
