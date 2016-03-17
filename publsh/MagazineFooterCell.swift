//
//  MagazineFooterCell.swift
//  publsh
//
//  Created by Itai Wiseman on 3/16/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class MagazineFooterCell: UITableViewCell {
    
    @IBOutlet var username: UIButton!
    @IBOutlet var followersBtn: UIButton!
    @IBOutlet var category1: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
