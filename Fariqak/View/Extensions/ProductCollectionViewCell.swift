//
//  ProductCollectionViewCell.swift
//  Fariqak
//
//  Created by Esslam Emad on 28/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var price: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
