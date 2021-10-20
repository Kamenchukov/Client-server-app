//
//  FotoViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import UIKit
import RealmSwift


class FotoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fotos: Results<UserPhoto>?
    var userId: Int?
    var vkService = VkService()
    let errorMessage = "Ошибка"
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        vkService.getPhotos(friendId: userId ?? 0) {
            self.collectionView.reloadData()
        }
        realmObserve()
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
extension FotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fotos?.count ?? 0
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fotoCell", for: indexPath) as! FotoViewCell
        
        
       
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let friendCarouselPhotoViewController = segue.destination as? FriendCarouselPhotoViewController,
              let indexCell = collectionView.indexPathsForSelectedItems?[0].row

        else { return }
        //friendCarouselPhotoViewController.userId = userId!
        friendCarouselPhotoViewController.photoId = indexCell
        
    }
    func realmObserve() {
        guard let realm = try? Realm() else { return }

        fotos = realm.objects(UserPhoto.self).filter("ownerId = \(Int(userId!))")
        token = fotos?.observe {[weak self] (changes: RealmCollectionChange) in

            guard let self = self,
                  let collectionView = self.collectionView else { return }

            switch changes {
                case .initial:
                    collectionView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                        collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                        collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                    }, completion: nil)
                case .error(let error):
                    fatalError("\(error)")
            }

        }

    }

}
