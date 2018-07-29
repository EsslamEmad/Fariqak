//
//  Chat.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation

struct Chat: Codable{
    var id: String = ""
    var isGroup: Bool = false
    var lastMsgTime: Int64 = 0
    var anotherID: String = ""
    var userId: [String]
    var photoUrl: String = ""
    var user = User()
    
    init() {
        userId = [String]()
    }
}
