//
//  ParseFriendsOperation.swift
//  VkApp
//
//  Created by Константин Каменчуков on 08.11.2021.
//

import Foundation

class ParseFriendsOperation: Operation {

     var outputFriends: Friends?

     override func main() {
         guard let getFriendsOperation = dependencies.first as? GetFriendsOperation,
               let data = getFriendsOperation.data else { return }


         do {
             let decoder = JSONDecoder()
             decoder.keyDecodingStrategy = .convertFromSnakeCase
             let friends = try decoder.decode(Friends.self, from: data)
             outputFriends = friends
         } catch  { print(error) }
     }
 }
