//
//  UserPhoto.swift
//  VkApp
//
//  Created by Константин Каменчуков on 03.10.2021.
//

import Foundation

struct UserPhotos: Codable {
     let response: UserPhotosResponse
 }

 struct UserPhotosResponse: Codable {
     let count: Int
     let items: [UserPhoto]
 }

 struct UserPhoto: Codable {
     let albumId: Int
     let date: Int
     let id: Int
     let ownerId: Int
     let photo130: String
     let photo604: String
     let photo75: String
     let photo807: String
     let photo1280: String
     let photo2560: String
    
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
