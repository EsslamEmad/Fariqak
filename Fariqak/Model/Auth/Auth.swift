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
import PromiseKit


class APIAuth {
    
    static let auth = APIAuth()
    
    var isLanguageSet: Bool{
        return language != nil
    }
    
    var language: String?{
        get {
            return Defaults().get(for: Key<String>("Language"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<String>("Language"))
            }
        }
    }
    
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
    
    var shoppingCart: [OrderItem]! {
        get {
            return Defaults().get(for: Key<[OrderItem]>("shopping cart"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<[OrderItem]>("shopping cart"))
            }
        }
    }
    
    var cities: [City]! {
        get {
            return Defaults().get(for: Key<[City]>("Cities"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<[City]>("Cities"))
            }
        }
    }
    
    var fcmToken: String! {
        get{
            return Defaults().get(for: Key<String>("Token"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<String>("Token"))
            }
        }
    }
    
    private init() {
    }
    
    
    private func getUserFromDefaults() -> User? {
        return Defaults().get(for: Key<User>("user"))
    }
    
    func updateToken(){
        if user != nil {
        if user?.token != fcmToken{
            user?.token = fcmToken
            firstly{
                return API.CallApi(APIRequests.updateUser(user: user!))
                } .done {
                    self.user = try! JSONDecoder().decode(User.self, from: $0)
                    print("Token updated")
                }.catch { error in
                    print("Unable to update token")
            }
        }
        }
    }
    
    func logout() {
        user = nil
        
    }
    
}
