//
//  Notification.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation


struct UserNotification: Codable{
    var title: String = ""
    var message: String = ""
    var type: String = ""
    var id: String = ""
    var itemID: String = ""
    var userID: String = ""
    var name: String = ""
    
    enum CodingKeys: String, CodingKey{
        case title
        case message
        case type
        case id
        case itemID = "item_id"
        case userID = "user_id"
        case name
    }
}
