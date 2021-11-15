//
//  GetFriendsOperation.swift
//  VkApp
//
//  Created by Константин Каменчуков on 08.11.2021.
//

import Foundation
import Alamofire

 class GetFriendsOperation: AsyncOpeation {
     var data: Data?

     let path = "friends.get"
     let baseURL: String
     let clientId: String
     let version: String
     let url: String
     let parameters: Parameters

     private var request: DataRequest

     init(baseURL: String, clientId: String, version: String) {
         self.baseURL = baseURL
         self.clientId = clientId
         self.version = version
         self.url = self.baseURL + self.path
         self.parameters = [
             "user_id": MySession.shared.userId ?? "0",
             "access_token": MySession.shared.token ?? "0",
             "v": self.version,
             "fields": "photo_100"
         ]
         self.request = AF.request(url, method: .get, parameters: parameters)
     }

     override func main() {
         self.request.responseData {
             [weak self] response in
             self?.data = response.value
             self?.state = .finished
             }
     }

     override func cancel() {
         request.cancel()
         super.cancel()
     }
 }
