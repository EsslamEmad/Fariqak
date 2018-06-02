//
//  RemoveTeamMember.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation


struct RemoveTeamMember: Codable{
    var playerID: String = ""
    var teamName: String = ""
    
    enum CodingKeys: String, CodingKey{
        case playerID = "players"
        case teamName = "name"
    }
}
