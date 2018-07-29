//
//  Product.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation

struct Product: Codable{
    var code: String = ""
    var name: String = ""
    var details: String = ""
    var itemPhoto: String? = ""
    var otherPhotos: String? = ""
    var countryID: String? = ""
    var cityID: String? = ""
    var lat: String?
    var lng: String?
    var price: String = ""
    var categoryID: String = ""
    var language: String? = ""
    
    var photos = [""]
    var rate: String = ""
    
    enum CodingKeys: String, CodingKey{
        case code
        case name
        case details
        case itemPhoto = "item_photo"
        case otherPhotos = "other_ photos"
        case countryID = "country_id"
        case cityID = "city_id"
        case lat
        case lng
        case price
        case categoryID = "category_id"
        case language
        
        case photos
        case rate
    }
    init() {
        
        
        return
    }
}
