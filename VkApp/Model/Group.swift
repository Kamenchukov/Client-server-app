//
//  Group.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import Foundation
import RealmSwift

struct Groups: Codable {
    let response: GroupsResponse
 }

 struct GroupsResponse: Codable {
    let count: Int
    let items: [Group]
 }

 class Group: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var photo200: String = ""
    
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
