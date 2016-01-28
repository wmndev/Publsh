//
//  CostumHeaderCell.swift
//  publsh
//
//  Created by Itai Wiseman on 1/13/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class CostumHeaderCell: UITableViewCell {

    @IBOutlet var followButton: UIButton!
    @IBOutlet var cellImage: UIImageView!

    @IBOutlet var userName: UILabel!

    @IBAction func followUser(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
