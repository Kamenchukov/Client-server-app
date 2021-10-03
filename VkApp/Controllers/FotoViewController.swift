//
//  FotoViewController.swift
//  VkApp
//
//  Created by Константин Каменчуков on 10.06.2021.
//

import UIKit



class FotoViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fotos: [UserPhoto] = []
    var userId: Int?
    var vkService = VkService(session: MySession.shared)
    let errorMessage = "Ошибка"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        vkService.getPhotos() { json in
                     print("Мои фото")
                     print(self.stringify(json) ?? self.errorMessage)
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
extension FotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fotos.count
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

}
