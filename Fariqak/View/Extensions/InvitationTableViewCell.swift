//
//  InvitationTableViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class InvitationTableViewCell: UITableViewCell {

    @IBOutlet weak var invitationImage: UIImageView!
    @IBOutlet weak var invitationIDLabel: UILabel!
    @IBOutlet weak var fromTeamLabel: UILabel!
    @IBOutlet weak var toTeamLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        invitationImage.layer.cornerRadius = 32.0
        invitationImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
