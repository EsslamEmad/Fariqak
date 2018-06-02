//
//  LoginRequest.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation


struct LoginRequest: Codable{
    let username: String!
    let password: String!

    enum CodingKeys: String, CodingKey{
        case username
        case password
    }


}
