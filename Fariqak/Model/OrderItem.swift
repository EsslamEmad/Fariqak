//
//  OrderItem.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation

struct OrderItem: Codable{
    var productID: String = ""
    var quantity: String = ""
    
    enum CodingKeys: String, CodingKey{
        case productID = "product_id"
        case quantity
    }
}
