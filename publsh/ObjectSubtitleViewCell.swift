//
//  ObjectSubtitleViewCell.swift
//  publsh
//
//  Created by Itai Wiseman on 2/21/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class ObjectSubtitleViewCell: UITableViewCell {

    @IBOutlet var username: UIButton!
    @IBOutlet var desc: UILabel!
    
    @IBAction func usernameTapped(sender: AnyObject) {
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
