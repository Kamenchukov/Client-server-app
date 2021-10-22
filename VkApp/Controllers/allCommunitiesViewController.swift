//
//  allCommunitiesViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class AllCommunitiesViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabelView: UITableView!
    var allCommunities: [Group] = []
    var foundCommunities = [Group]()
    var searching = false
    let vkService = VkService()
    var allGroups = [Group]()
    private let ref = Database.database().reference(withPath: "authUser")
    let errorMessage = "Ошибка"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        self.searchBar.delegate = self
        
        loadData()
        tabelView.reloadData()
        
        vkService.getGroups() {
            self.loadData()
            self.tabelView.reloadData()
                 }
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

    extension AllCommunitiesViewController: UITableViewDataSource, UITableViewDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allGroups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroups", for: indexPath) as! AllCommunitiesViewCell
        
        cell.allCommunitiesName.text = allGroups[indexPath.item].name
    
        
        return cell
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let userRef = ref.child(MySession.shared.userId ?? "0")
            
            print(userRef)
            
            let groupRef = userRef.child("\(allGroups[indexPath.item].id)")
            
            groupRef.setValue([
                "groupID": allGroups[indexPath.item].id,
                "groupName": allGroups[indexPath.item].name
            ])
            
        }
    
        public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            foundCommunities = searchText != "" ? allCommunities.filter {$0.name.lowercased().contains(searchText.lowercased())} : allCommunities
            searching = true
            tabelView.reloadData()
        }
        
        public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searching = false
            searchBar.text = ""
            tabelView.reloadData()
        }
        func loadData() {
                 do {
                     let realm = try Realm()
                     let gorups = realm.objects(Group.self)
                    self.allCommunities = Array(gorups)

                 } catch { print(error) }
             }
}
