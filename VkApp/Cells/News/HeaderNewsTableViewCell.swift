//
//  HeaderNewsTableViewCell.swift
//  VkApp
//
//  Created by Константин Каменчуков on 01.11.2021.
//

import UIKit

class HeaderNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var photo: UIImage!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo = UIImage(named: "friends")
        name.text = "Petrov Sviatoslav"
        date.text = "23.02.2022"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
