//
//  Group.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import Foundation

//struct GroupModel {
//    let name: String
//    let foto: String
//}
//
//struct GroupData {
//    static let shared = GroupData()
//    var groupData:[GroupModel]
//
//    private init() {
//        groupData = [
//                     GroupModel(name: "Demolition Ranch", foto: "Matt"),
//                     GroupModel(name: "We love Drake", foto: "Drake"),
//                     GroupModel(name: "Fit girls", foto: "fit"),
//                    ]
//    }
//}
struct Groups: Codable {
     let response: GroupsResponse
 }

 struct GroupsResponse: Codable {
     let count: Int
     let items: [Group]
 }

 struct Group: Codable {
     let id: Int
     let name: String
     let screenName: String
     let type: String
     let photo50: String
     let photo100: String
     let photo200: String
    
     enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case screenName = "screen_Name"
        case type = "type"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
        
    }
 }
