//
//  FavouriteCheeseCell.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-08.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class FavouriteCheeseCell: UITableViewCell {

    @IBOutlet var cheeseName: UILabel!
    @IBOutlet var manufacturer: UILabel!
    @IBOutlet var flavourDescription: UILabel!
    @IBOutlet var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
