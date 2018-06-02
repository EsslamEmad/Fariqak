//
//  User.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation


struct User: Codable, JSONSerializable{
    var id: String = ""
    var firebaseID: String? = ""
    var type: String = "1"
    var token: String = ""
    var username: String = ""
    var email: String = ""
    var photos: String = ""
    var phone: String = ""
    var lat: String = "0.0"
    var lng: String = "0.0"
    var countryID: String? = ""
    var cityID: String = ""
    var rate: String? = "0.0"
    
    enum CodingKeys: String, CodingKey{
        case id
        case firebaseID = "firebase_id"
        case type
        case token
        case username
        case email
        case photos
        case phone
        case lat
        case lng
        case countryID = "country_id"
        case cityID = "city_id"
        case rate
    }
    init() {
        
        
        return
    }
}


