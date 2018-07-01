//
//  MyTeamTableViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class MyTeamTableViewCell: UITableViewCell {

    @IBOutlet var teamLogo: UIImageView!
    @IBOutlet var teamNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teamLogo.layer.cornerRadius = 32.0
        teamLogo.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
