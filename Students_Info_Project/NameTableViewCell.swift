//
//  NameTableViewCell.swift
//  homework4
//
//  Created by HAO LI on 9/20/15.
//  Copyright (c) 2015 Physaologists. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    // MARK: properties
    @IBOutlet weak var nameImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
