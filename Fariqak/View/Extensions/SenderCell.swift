//
//  SenderCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 22/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        //self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        background.layer.cornerRadius = 10.0
        background.clipsToBounds = true

    }
}
