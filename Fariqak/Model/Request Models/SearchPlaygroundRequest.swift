//
//  SearchPlaygroundRequest.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation


struct SearchPlaygroundRequest: Codable{
    var text: String? = ""
    var cityID: String
    
    enum CodingKeys: String, CodingKey{
        case text
        case cityID = "city_id"
    }
    init(text: String, cityID: String){
        self.text = text
        self.cityID = cityID
    }
}
