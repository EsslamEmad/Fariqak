//
//  PlaygroundTableViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 11/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class PlaygroundTableViewCell: UITableViewCell {

    @IBOutlet var playgroundImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
