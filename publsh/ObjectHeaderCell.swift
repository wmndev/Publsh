//
//  ObjectHeaderCell.swift
//  publsh
//
//  Created by Itai Wiseman on 2/21/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class ObjectHeaderCell: UITableViewCell {
    
    @IBOutlet var publshLbl: UILabel!
    
    @IBOutlet var targetImage: UIImageView!
    
    @IBOutlet var followBtn: UIButton!
    
    //@IBOutlet var fullName: UILabel!
    
    @IBOutlet var username: UIButton!
    
    @IBOutlet var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
