//
//  FriendsViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import UIKit
import RealmSwift
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
class FriendsViewController: UIViewController {
    
    @IBOutlet weak var tabelView: UITableView!
    
    var users: [UserModel] = []
    private var firstLetters = [String]()
    private var sortedUsers = [[UserModel]]()
    let vkService = VkService()
    var token: NotificationToken?

    let errorMessage = "Ошибка"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.register(SectionHeaderTableView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderTableView.identifier)
        
//        firstLetters = getFirstLetters(users)
//        sortedUsers = sortedUsers(users, letters: firstLetters)
//        vkService.getFriendsList() { [weak, self] in
//            self?.loadData()
//            self?.tableView.reloadData()
//                    // print(self.stringify(json) ?? self.errorMessage)
//                 }
        vkService.getFriendsList() {
            self.tabelView.reloadData()
        }
        observeRealm()
        
    }
    func stringify(_ json: Any?) -> String? {
             guard let json = json else {
                 return nil
             }

             do {
                 let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                 if let string = String(data: data, encoding: String.Encoding.utf8) {
                     return string
                 }
             } catch {
                 print(error)
             }

             return nil
         }
    
    
//    private func sortedUsers(_ users: [UserModel], letters: [String]) -> [[UserModel]] {
//        var sortedUsers = [[UserModel]]()
//
//        letters.forEach { letter in
//            let letterUser = users.filter { String($0.name.prefix(1)) == letter }.sorted(by: { $0.name < $1.name })
//            sortedUsers.append(letterUser)
//        }
//
//        return sortedUsers
//    }
//
//    private func getFirstLetters(_ users: [UserModel]) -> [String] {
//        let usersName = users.map { $0.name }
//        let firstLetters = Array(Set(usersName.map { String($0.prefix(1)) })).sorted()
//        return firstLetters.removeDuplicates()
//    }
//
}
    // MARK: - Table view data source

    extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {

        func numberOfSections(in tableView: UITableView) -> Int {
            sortedUsers.count
        }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedUsers[section].count
    }
    //users
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as? FriendsViewCell
    else {//cell.configure(users[indexPath.row])
        return UITableViewCell()
            
    }
        let user = sortedUsers[indexPath.section][indexPath.row]
        let friend: UserModel = users[indexPath.row]
        cell.textLabel?.text = "\(friend.firstName) \(friend.lastName)"
        return cell
    }

         func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return firstLetters[section]
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            30
        }
        func observeRealm() {
            do {
                         let realm = try Realm()
                         token = realm.objects(UserModel.self).observe { [weak self] (changes: RealmCollectionChange) in
                             guard let self = self,
                                   let tableView = self.tabelView else { return }

                             self.users = Array(realm.objects(UserModel.self))
                            if self.users.count > 0 {
    
                             }

                             switch changes {
                                 case .initial, .update:
                                     tableView.reloadData()
                                 case .error(let error):
                                     fatalError("\(error)")
                             }
                         }
                     } catch { print(error) }
                }
        
        // MARK: - Navigation
        
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//            guard let fotoViewController = segue.destination as? FotoViewController,
//                  let indexRow = tableView.indexPathForSelectedRow?.row
//            else {
//                return
//            }
//
//            let indexSection = tableView.indexPathForSelectedRow!.section
//
//            fotoViewController.userID = sortedFriends[indexSection][indexRow].id
//        }
}
