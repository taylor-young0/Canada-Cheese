//
//  CheeseDetailCell.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-08.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class CheeseDetailCell: UITableViewCell {

    @IBOutlet var propertyName: UILabel!
    @IBOutlet var propertyValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
