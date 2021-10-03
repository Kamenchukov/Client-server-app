//
//  User.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import Foundation
import RealmSwift

//struct UserModel {
//    let name: String
//    let foto: String
//
//
//}
//
//struct UsersData {
//    static let shared = UsersData()
//    var usersData: [UserModel]
//
//    private init() {
//        usersData = [UserModel(name: "Ross", foto: "Ross_Geller"),
//                     UserModel(name: "Chandler", foto: "Chandler_Bing"),
//                     UserModel(name: "Joey", foto: "Joeyftribbiani"),
//                     UserModel(name: "Phoebe", foto: "Phoebe_buffay"),
//                     UserModel(name: "Monica", foto: "Monicaegeller"),
//                     UserModel(name: "Rachel", foto: "JenniferAnistonFeb09"),
//                     ]
//    }
//}
//
//struct UserFoto {
//
//    let foto: String
//
//}
//
//struct UsersFotoData {
//    static let shared = UsersFotoData()
//    var userFoto: [UserFoto]
//
//    private init() {
//        userFoto = [UserFoto(foto: "Ross_Geller"),
//                    UserFoto(foto: "Chandler_Bing"),
//                    UserFoto(foto: "Joeyftribbiani"),
//                    UserFoto(foto: "Monicaegeller"),
//                    UserFoto(foto: "Phoebe_buffay"),
//                    UserFoto(foto: "JenniferAnistonFeb09"),]
//    }
//
//}
struct Friends: Codable {
    let response: FriendsResponse
}

// MARK: - Response
struct FriendsResponse: Codable {
    let count: Int
    let items: [UserModel]
}

// MARK: - Item
class UserModel: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var lastName: String
    @objc dynamic var photo50: String
    @objc dynamic var trackCode, firstName: String
    @objc dynamic var photo100: String 

    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "last_name"
        case photo50 = "photo_50"
        case trackCode = "track_code"
        case firstName = "first_name"
        case photo100 = "photo_100"
    }
}
