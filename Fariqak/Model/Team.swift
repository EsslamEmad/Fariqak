//
//  Team.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation

struct Team: Codable{
    var teamID: String?
    var players: [String] = [String]()
    var name: String?
    var logo: String
    var teamLeader: String?
    
    enum CodingKeys: String, CodingKey{
        case teamID = "team_id"
        case players
        case name
        case logo
        case teamLeader = "team_leader"
    }
}
