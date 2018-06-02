//
//  order.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation


struct Order: Codable{
    var id: String = ""
    var userID:  String = ""
    var details: String = ""
    var products: [OrderItem] = [OrderItem]()
    var totalPrice: Int = 0
    var state: String = ""
    var address: String = ""
    var payment: String = ""
    var name: String = ""
    var bank: String = ""
    var photo: String = ""
    
    enum CodingKeys: String, CodingKey{
        case id = "order_id"
        case userID = "user_id"
        case details
        case products
        case totalPrice = "total_ price"
        case state = "status"
        case address
        case payment
        case name
        case bank
        case photo
    }
}
