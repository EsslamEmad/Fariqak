//
//  ChoosePlayerTableViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 24/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class ChoosePlayerTableViewCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.clipsToBounds = true
        img.layer.cornerRadius = img.bounds.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
