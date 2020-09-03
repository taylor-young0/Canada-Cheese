//
//  CheeseTableViewCell.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class CheeseTableViewCell: UITableViewCell {

    @IBOutlet var cheeseName: UILabel!
    @IBOutlet var manufacturer: UILabel!
    @IBOutlet var flavourDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
