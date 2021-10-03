//
//  allCommunitiesViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import UIKit

class AllCommunitiesViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabelView: UITableView!
    var allCommunities: [Group] = []
    var foundCommunities = [Group]()
    var searching = false
    let vkService = VkService(session: MySession.shared)
    var allGroups = [Group]()

    let errorMessage = "Ошибка"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        self.searchBar.delegate = self
        
        vkService.getGroups() { [weak self] groups in
            self?.allGroups = groups as! [Group]
            self?.tabelView.reloadData()
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
}
