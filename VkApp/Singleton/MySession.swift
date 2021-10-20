//
//  MySession.swift
//  VkApp
//
//  Created by Константин Каменчуков on 28.09.2021.
//

import UIKit

 final class MySession {
     static let shared = MySession()

     private init() {}

     var token: String?
     var userId: Int?
 }
