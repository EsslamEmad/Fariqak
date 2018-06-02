//
//  Invitation.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation


struct Invitation: Codable{
    var id: String = ""
    var fromTeam: String = ""
    var toTeam: String = ""
    var playgroundID: String = ""
    var reservationID: String = ""
    var fromTime: String = ""
    var toTime: String = ""
    var status: String = ""
    
    enum CodingKeys: String, CodingKey{
        case id
        case fromTeam = "from_team"
        case toTeam = "to_team"
        case playgroundID = "playground_id"
        case reservationID = "reservation_id"
        case fromTime = "from_time"
        case toTime = "to_time"
        case status
    }
}
