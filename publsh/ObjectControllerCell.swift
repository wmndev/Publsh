//
//  ObjectControllerCell.swift
//  publsh
//
//  Created by Itai Wiseman on 3/10/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class ObjectControllerCell: UITableViewCell {
    @IBOutlet var followingBtn: UIButton!
    @IBOutlet var activityBtn: UIButton!
    @IBOutlet var followersBtn: UIButton!
    @IBOutlet var totalBtn: UIButton!


    
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
