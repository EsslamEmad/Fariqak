//
//  Reservation.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation

struct Reservation: Codable{
    var id: String = ""
    var teamLeaderID: String = ""
    var status: String = ""
    var date: String = ""
    var fromHour: String = ""
    var toHour: String = ""
    var playgroundID: String = ""
    var payment: String = ""
    var name: String = ""
    var bank: String = ""
    var photo: String = ""
    
    enum CodingKeys: String, CodingKey{
        case id
        case teamLeaderID = "team_leader_id"
        case status
        case date
        case fromHour = "from_hour"
        case toHour = "to_hour"
        case playgroundID = "playground_id"
        case payment
        case name
        case bank
        case photo
    }
}
