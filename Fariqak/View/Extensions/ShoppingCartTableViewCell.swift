//
//  ShoppingCartTableViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 8/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {

    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
