//
//  API Request.swift
//  Fariqak
//
//  Created by Esslam Emad on 19/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation
import Moya

enum APIRequests {
    
    
    case register(user: User)
    case getUser(id: String) //User.uid
    case getUserByID(id: String) //User.id
    case updateUser(user: User)
    case addPlayground(playground: Playground)
    case getPlayground(id: String)
    case editPlayground(id: String, playground: Playground)
    case getPlaygrounds()
    case getPlaygroundsInCity(cityID: String)
    case searchPlaygrounds(searchRequest: SearchPlaygroundRequest)
    case upload(photo: UIImage)
    case getOwnerPlaygrounds(ownerID: String)
    case getUserTeams(userID: String)
    case getTeams()
    case getTeamByID(id: String)
    case addTeam(team: Team)
    case editTeam(id: String, team: Team)
    case removeTeamMember(removeRequest: RemoveTeamMember)
    case searchTeams(searchRequest: SearchRequest)
    case searchUsers(searchRequest: SearchRequest)
    case getCategories()
    case getProductsIn(categoryID: String)
    case getProductBy(id: String)
    case saveOrder(order: Order)
    case getOrdersOfUser(userID: String)
    case getOrder(id: String)
    case getCities()
    case addReservation(reservation: Reservation)
    case getReservation(id: String)
    case getReservationsOfUser(userID: String)
    case getReservationsOfOwner(ownerID: String)
    case acceptReservation(reservationID: String, statusRequest: StatusRequest)
    case getNotificationsOfUser(userID: String)
    case getCommingInvitationsOfUser(userID: String)
    case getOutcommingInvitationsOfUser(userID: String)
    case addInvitation(invitation: Invitation)
    case acceptInvitation(invitationID: String, statusRequest: StatusRequest)
    case sendNotification(notification: UserNotification)
    case rateProduct(productID: String, rateRequest: RateProductRequest)
    case ratePlayground(playgroundID: String, rateRequest: RateProductRequest)
    case contactUs(content: ContactUs)
    case getSettings()
    case acceptTeamMember(teamID: String, playerID: String)
    
}


extension APIRequests: TargetType{
    var baseURL: URL{
        let l: String
        switch Language.language{
        case .english: l = "en"
        default: l = "ar"
        }
        return URL(string: "https://y.scit-sa.com/playgrounds/\(l)/mobile/")!
    }
    var path: String{
        switch self{
        case .acceptTeamMember:
            return "accept_teamMember"
        case .acceptReservation(reservationID: let id):
            return "accept_reservation/\(id)"
        case .register:
            return "register"
        case .updateUser:
            return "update_user"
        case .getCities():
            return "cities"
        case .getUser(id: let id):
            return "getUser/\(id)"
        case .getUserByID(id: let id):
            return "getUserById/\(id)"
        case .addPlayground:
            return "addPlayground"
        case .getPlayground(id: let id):
            return "playground/\(id)"
        case .editPlayground(id: let id):
            return "editPlayground/\(id)"
        case .getPlaygrounds():
            return "playgrounds"
        case .getPlaygroundsInCity(cityID: let id):
            return "playgrounds/\(id)"
        case .searchPlaygrounds:
            return "searchPlaygrounds"
        case .upload:
            return "upload"
        case .getOwnerPlaygrounds(ownerID: let id):
            return "myPlaygrounds/\(id)"
        case .getUserTeams(userID: let id):
            return "teams/\(id)"
        case .getTeams():
            return "teams"
        case .getTeamByID(id: let id):
            return "team/\(id)"
        case .addTeam:
            return "addTeam"
        case .editTeam(id: let id):
            return "editTeam/\(id)"
        case .removeTeamMember:
            return "removeMemberOfTeam"
        case .searchTeams:
            return "searchTeams"
        case .searchUsers:
            return "searchUsers"
        case .getCategories():
            return "catagories"
        case .getProductsIn(categoryID: let id):
            return "products/\(id)"
        case .getProductBy(id: let id):
            return "product/\(id)"
        case .saveOrder:
            return "save_order"
        case .getOrdersOfUser(userID: let id):
            return "orders/\(id)"
        case .getOrder(id: let id):
            return "order/\(id)"
        case .addReservation:
            return "addReservation"
        case .getReservation(id: let id):
            return "reservation/\(id)"
        case .getReservationsOfUser(userID: let id):
            return "reservtions/\(id)"
        case .getReservationsOfOwner(ownerID: let id):
            return "ownerReservation/\(id)"
        case .getNotificationsOfUser(userID: let id):
            return "notification/\(id)"
        case .getCommingInvitationsOfUser(userID: let id):
            return "comming_invitation/\(id)"
        case .getOutcommingInvitationsOfUser(userID: let id):
            return "outcomming_invitation/\(id)"
        case .addInvitation:
            return "addInvitation"
        case .acceptInvitation(invitationID: let id):
            return "accept_Invitation/\(id)"
        case .sendNotification:
            return "sendNotification"
        case .rateProduct(productID: let id):
            return "rateProduct/\(id)"
        case .ratePlayground(playgroundID: let id):
            return "ratePlayground/\(id)"
        case .contactUs:
            return "contactus"
        case .getSettings():
            return "get_settings"
        }
    }
    
    
    var method: Moya.Method{
        switch self {
        case .register, .updateUser, .addPlayground, .editPlayground, .searchPlaygrounds, .upload, .addTeam, .editTeam, .removeTeamMember, .searchTeams, .searchUsers, .saveOrder, .addReservation, .acceptReservation, .addInvitation, .sendNotification, .rateProduct, .ratePlayground, .contactUs:
            return .post
        default:
            return .get
        }
    }
    
    
    var task: Task{
        switch self{
            
        case .register(user: let user1):
            return .requestJSONEncodable(user1)
           // return .requestParameters(parameters: ["user": user1.toJSON() as Any, "username": "essess"], encoding: JSONEncoding.default)
            
        case .updateUser(user: let user):
            return .requestJSONEncodable(user)
            
        case .addPlayground(playground: let p):
            return .requestJSONEncodable(p)
            
        case .editPlayground(id: _, playground: let p):
            return .requestJSONEncodable(p)
            
        case .searchPlaygrounds(searchRequest: let search):
            return .requestJSONEncodable(search)
            
        case .upload(photo: let image):
            let data = UIImageJPEGRepresentation(image, 0.75)!
            let imageData = MultipartFormData(provider: .data(data), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            let multipartData = [imageData]
            return .uploadMultipart(multipartData)
            
        case .addTeam(team: let team):
            return .requestJSONEncodable(team)
            
        case .editTeam(id: _, team: let team):
            return .requestJSONEncodable(team)
            
        case .removeTeamMember(removeRequest: let remove):
            return .requestJSONEncodable(remove)
            
        case .searchTeams(searchRequest: let search):
            return .requestJSONEncodable(search)
            
        case .searchUsers(searchRequest: let search):
            return .requestJSONEncodable(search)
            
        case .saveOrder(order: let order):
            return .requestJSONEncodable(order)
            
        case .addReservation(reservation: let r):
            return .requestJSONEncodable(r)
            
        case .acceptReservation(reservationID: _, statusRequest: let sr):
            return .requestJSONEncodable(sr)
            
        case .addInvitation(invitation: let i):
            return .requestJSONEncodable(i)
            
        case .acceptInvitation(invitationID: _, statusRequest: let sr):
            return .requestJSONEncodable(sr)
            
        case .sendNotification(notification: let n):
            return .requestJSONEncodable(n)
            
        case .rateProduct(productID: _,rateRequest: let rpr):
            return .requestJSONEncodable(rpr)
            
        case .ratePlayground(playgroundID: _, rateRequest: let rpr):
            return .requestJSONEncodable(rpr)
            
        case .contactUs(content: let cu):
            return .requestJSONEncodable(cu)
            
        default:
            return .requestPlain
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json",
                "client": "8657aa4f41272c56967138c2b368c2a640adeea0",
                "secret": "306e8ac887a41ae68e7e9e385a68878ca56d4bc8"]
    }
}
