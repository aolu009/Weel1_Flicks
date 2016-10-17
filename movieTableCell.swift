//
//  movieTableCell.swift
//  Weel1_Flicks
//
//  Created by Lu Ao on 10/15/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class movieTableCell: UITableViewCell {

    @IBOutlet weak var moviePost: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
