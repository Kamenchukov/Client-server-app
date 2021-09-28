//
//  FriendsViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import UIKit
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
    
    var users = UsersData.shared.usersData
    private var firstLetters = [String]()
    private var sortedUsers = [[UserModel]]()
    var vkService = VkService(session: MySession.shared)
        
    let errorMassage = "Ошибка"
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.register(SectionHeaderTableView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderTableView.identifier)
        
        firstLetters = getFirstLetters(users)
        sortedUsers = sortedUsers(users, letters: firstLetters)
        
        vkService.getFriendsList() { json in
            print("Список друзей")
            print(self.stringify(json) ?? self.errorMassage)
        }
    }
    
    private func sortedUsers(_ users: [UserModel], letters: [String]) -> [[UserModel]] {
        var sortedUsers = [[UserModel]]()
        
        letters.forEach { letter in
            let letterUser = users.filter { String($0.name.prefix(1)) == letter }.sorted(by: { $0.name < $1.name })
            sortedUsers.append(letterUser)
        }
       
        return sortedUsers
    }
    
    private func getFirstLetters(_ users: [UserModel]) -> [String] {
        let usersName = users.map { $0.name }
        let firstLetters = Array(Set(usersName.map { String($0.prefix(1)) })).sorted()
        return firstLetters.removeDuplicates()
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
        cell.configure(user)
        return cell
    }

         func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return firstLetters[section]
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            30
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
