//
//  Auth.swift
//  Fariqak
//
//  Created by Esslam Emad on 11/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation
import DefaultsKit
import FirebaseAuth


class APIAuth {
    
    static let auth = APIAuth()
    
    var isSignedIn: Bool {
        get {
            return user != nil
        }
    }
    
    var user: User? {
        get {
            return getUserFromDefaults()
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<User>("user"))
            } else {
                UserDefaults.standard.set(nil, forKey: "user")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    private init() {
    }
    
    private func getUserFromDefaults() -> User? {
        return Defaults().get(for: Key<User>("user"))
    }
    
    func logout() {
        user = nil
        
    }
    
}
