//
//  Playground.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation

struct Playground: Codable{
    var id: String = ""
    var code: String = ""
    var title: String = ""
    var details: String = ""
    var photo: String = ""
    var price: String = ""
    var owner: String = ""
    var lat: Double?
    var lng: Double?
    var countryID: String = ""
    var cityID: String = ""
    var otherPhotos: [String]?
    var rate: String?
    var photos: [String]?
    
    enum CodingKeys: String, CodingKey{
        case id
        case code
        case title
        case details
        case photo = "item_photo"
        case price
        case owner = "playground_owner"
        case lat
        case lng
        case countryID = "country_id"
        case cityID = "city_id"
        case otherPhotos = "other_photos"
        case rate
        case photos
    }
}
