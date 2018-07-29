//
//  ConversationTBCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 21/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class ConversationsTBCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func clearCellData()  {
        self.nameLabel.font = UIFont(name:"AvenirNext-Regular", size: 17.0)
        profilePic.image = UIImage(named: "man")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = profilePic.bounds.width / 2.0
    }
    
}
