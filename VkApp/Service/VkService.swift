////
////  VkService.swift
////  VkApp
////
////  Created by Константин Каменчуков on 16.07.2021.
////
import Foundation
import RealmSwift
import Alamofire
 class VkService {

    let baseURL = "https://api.vk.com/method/"
         let clientId = "7823707"
         let version = "5.21"

         let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

     func getFriendsList(completion: @escaping () -> Void) {
     let path = "friends.get"

     let parameters: Parameters = [
         "user_id": MySession.shared.userId ?? "0",
         "access_token": MySession.shared.token ?? "0",
         "v": version,
         "fields": "photo_100"
     ]

     let url = baseURL + path

     AF.request(url, method: .get, parameters: parameters).responseData {
         response in
             guard let data = response.value else { return }
             do {
                 let decoder = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 let users = try decoder.decode(Friends.self, from: data)

                 self.saveFriendsList(users.response.items)
                 completion()
             } catch {
                 print(error)
             }
         }
 }
    func saveFriendsList(_ friends: [UserModel]) {
        do {
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            realm.add(friends, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    func getPhotos(friendId: String = MySession.shared.userId!, completion: @escaping () -> Void) {
        let path = "photos.getAll"

        print(friendId)

        let parameters: Parameters = [
            "owner_id": friendId,
            "access_token": MySession.shared.token ?? "0",
            "v": version,
            "no_service_albums": 0,
            "count": 50,
            "extended": 1
        ]
         let url = baseURL + path

        AF.request(url, method: .get, parameters: parameters).responseData {
            response in
            guard let data = response.value else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photos = try decoder.decode(UserPhotos.self, from: data)
                self.savePhoto(photos.response.items)
                completion()
            } catch {
                print(error)
            }
        }
    }
    func savePhoto(_ photos: [UserPhoto]) {
        do {
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            realm.add(photos, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

     func getGroups(completion: @escaping () -> Void) {
        let path = "groups.get"

        let parameters: Parameters = [
            "user_id": MySession.shared.userId ?? "0",
            "access_token": MySession.shared.token ?? "0",
            "v": version,
            "extended": "1"
        ]

        let url = baseURL + path

        AF.request(url, method: .get, parameters: parameters).responseData {
            response in
            guard let data = response.value else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let groups = try decoder.decode(Groups.self, from: data)
                self.saveGroups(groups.response.items)
                completion()
            } catch {
                print(error)
            }
        }
    }
    func saveGroups(_ groups: [Group]) {
        do {
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            realm.add(groups, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }


//     private func perform(_ urlComponents: URLComponents, _ completion: @escaping (Any?) -> ()) {
//         let task = VKSession.dataTask(with: urlComponents.url!) {(data, response, error) in
//             let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//             completion(json ?? nil)
//         }
//         task.resume()
//     }
 }
