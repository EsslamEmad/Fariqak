//
//  ReceiverCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 22/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seenImage: UIImageView!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        seenImage.image = UIImage(named: "verification-mark")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        background.layer.cornerRadius = 10.0
        background.clipsToBounds = true
        seenImage.image = UIImage(named: "verification-mark")
    }
}
