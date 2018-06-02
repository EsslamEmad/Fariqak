//
//  Message.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation

struct Message: Codable{
    var text: String? = ""
    var user: String? = ""
    var type: String? = ""
    var userID: String? = ""
    var date: Date?
    var seen: Bool = false
    enum CodingKeys: String, CodingKey{
        case text
        case user
        case type
        case userID = "user_id"
        case date
        case seen
    }
}
