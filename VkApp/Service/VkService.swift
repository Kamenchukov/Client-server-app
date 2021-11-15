////
////  VkService.swift
////  VkApp
////
////  Created by Константин Каменчуков on 16.07.2021.
////
import Foundation
import RealmSwift
import Alamofire
import PromiseKit

 class VkService {

    let baseURL = "https://api.vk.com/method/"
         let clientId = "7823707"
         let version = "5.21"

         let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

     func getFriendsList(completion: @escaping () -> Void) {
     let friendsOperationQueue = OperationQueue()

     let getFriendsOperation = GetFriendsOperation(baseURL: baseURL, clientId: clientId, version: version)
     let parseFriendsOperation = ParseFriendsOperation()
     let saveFriendsOperation = SaveFriendsOperation()

     parseFriendsOperation.addDependency(getFriendsOperation)
     saveFriendsOperation.addDependency(parseFriendsOperation)

     friendsOperationQueue.addOperation(getFriendsOperation)
     friendsOperationQueue.addOperation(parseFriendsOperation)
     friendsOperationQueue.addOperation(saveFriendsOperation)
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
     func loadCommunities() {

                  getGroups()
                  .then(parseCommunitiesPromise(_:))
                  .get { data in
                      print(data[0])
                  }
                  .done(saveGroups(_:))
                  .catch { error in
                      print(error)
                  }
          }
     func getGroups() -> Promise<Data> {
        let path = "groups.get"

        let parameters: Parameters = [
            "user_id": MySession.shared.userId ?? "0",
            "access_token": MySession.shared.token ?? "0",
            "v": version,
            "extended": "1"
        ]

        let url = baseURL + path

         return Promise { resolver in
                      AF.request(url, method: .get, parameters: parameters).responseData {
                          response in
                          guard let data = response.value else {
                              resolver.reject(AppError.noDataProvided)
                              return
                          }

                          resolver.fulfill(data)
                      }
                  }
    }
     func parseCommunitiesPromise(_ data: Data) -> Promise<[Group]> {

              return Promise { resolver in
                  do {
                      let decoder = JSONDecoder()
                      decoder.keyDecodingStrategy = .convertFromSnakeCase
                      let groups = try decoder.decode(Groups.self, from: data)
                      resolver.fulfill(groups.response.items)
                  } catch { resolver.reject(AppError.failedToDecode) }
              }
          }
    func saveGroups(_ groups: [Group]) {
        do {
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            realm.add(groups, update: .modified)
            try realm.commitWrite()
        } catch {
            print(AppError.noDataSave)
        }
    }
    //MARK: - load news
    func loadNews(results: @escaping ([NewsItem], [NewsProfiles], [NewsGroups]) -> Void) {
             let path = "newsfeed.get"
             let parameters: Parameters = [
                 "filters": "post",
                "access_token": MySession.shared.token ?? "0",
                 "v": version,
                 "count": 5
             ]
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON {
                     response in
            guard let json = response.value else { return }

                         let result = json as! [String: Any]
                         let response = result["response"] as! [String: Any]

                         var posts: [NewsItem] = []
                         var profiles: [NewsProfiles] = []
                         var groups: [NewsGroups] = []
                         let dispatchGroup = DispatchGroup()

                         DispatchQueue.global().async(group: dispatchGroup) {
                             let postsJson = response["items"] as! [[String: Any]]
                             posts = postsJson.map { NewsItem(json: $0) }
                         }

                         DispatchQueue.global().async(group: dispatchGroup) {
                             let profilesJson = response["profiles"] as! [[String: Any]]
                             profiles = profilesJson.map { NewsProfiles(json: $0) }
                         }

                         DispatchQueue.global().async(group: dispatchGroup) {
                             let groupsJson = response["groups"] as! [[String: Any]]
                             groups = groupsJson.map { NewsGroups(json: $0) }
                         }

                         dispatchGroup.notify(queue: DispatchQueue.main) {
                             results(posts, profiles, groups)
                         }
                     }
                 }
 }
