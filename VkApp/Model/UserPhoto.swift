//
//  UserPhoto.swift
//  VkApp
//
//  Created by Константин Каменчуков on 03.10.2021.
//

import Foundation
import RealmSwift
struct UserPhotos: Codable {
     let response: UserPhotosResponse
 }

 struct UserPhotosResponse: Codable {
     let count: Int
     let items: [UserPhoto]
 }

 class UserPhoto: Object, Codable {
    @objc dynamic var albumId: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var photo130: String = ""
    @objc dynamic var photo604: String = ""
    @objc dynamic var photo75: String = ""
    @objc dynamic var photo807: String = ""
    @objc dynamic var photo1280: String = ""
    @objc dynamic var photo2560: String = ""
    
    enum CodingKeys: String, CodingKey{
        case albumId
        case date
        case id
        case ownerId
        case photo130 = "photo_130"
        case photo604 = "photo_604"
        case photo75 = "photo_75"
        case photo807 = "photo_807"
        case photo1280 = "photo_1280"
        case photo2560 = "photo_2560"
            
    }
 }
