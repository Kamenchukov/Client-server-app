//
//  MyCommunitiesViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import UIKit
import RealmSwift

class MyCommunitiesViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var communities:[Group] = []
    var myGroups: Results<Group>?
    var vkService = VkService()
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        vkService.getGroups()
        realmObserve()
        
        }
    
    
    @IBAction func addGroup(_ segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
        guard
            let sourceController = segue.source as? AllCommunitiesViewController
        else { return }
            if let indexPath = sourceController.tabelView.indexPathForSelectedRow {
               let group = sourceController.allCommunities[indexPath.row]

                if !communities.contains(where: { $0.name == group.name}) {
                        communities.append(group)
                        tableView.reloadData()
        }
      }
    }
  }
    
}
    // MARK: - Table view data source
    extension MyCommunitiesViewController: UITableViewDataSource, UITableViewDelegate {
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myGroups?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroups", for: indexPath) as! AllCommunitiesViewCell
        
        guard let group = myGroups?[indexPath.item] else {return cell}
        cell.textLabel?.text = group.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            communities.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 }

extension MyCommunitiesViewController {
    func realmObserve() {
        guard let realm = try? Realm() else { return }
                 myGroups = realm.objects(Group.self)

                 token = myGroups?.observe { [weak self] (changes: RealmCollectionChange) in
                     guard let self = self,
                           let tableView = self.tableView else { return }

                     switch changes {
                         case .initial:
                             tableView.reloadData()
                         case .update(_, let deletions, let insertions, let modifications):
                             tableView.beginUpdates()
                             tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                                  with: .automatic)
                             tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                                  with: .automatic)
                             tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                                  with: .automatic)
                             tableView.endUpdates()
                         case .error(let error):
                             fatalError("\(error)")
                     }
                 }
    }
}
