//
//  FooterNewsTableViewCell.swift
//  VkApp
//
//  Created by Константин Каменчуков on 01.11.2021.
//

import UIKit

class FooterNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var commentNumber: UILabel!
    
    @IBOutlet weak var shareNumber: UILabel!
    
    @IBOutlet weak var viewsNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
