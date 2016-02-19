//
//  MagazineIntroductionCell.swift
//  publsh
//
//  Created by Itai Wiseman on 1/30/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class MagazineIntroductionCell: UITableViewCell {

    
    @IBOutlet var targetImage: UIImageView!
    
    @IBOutlet var magazinesBtn: UIButton!
    
    @IBOutlet var followersBtn: UIButton!
    
    @IBOutlet var followingBtn: UIButton!
    
    @IBOutlet var followBtn: UIButton!
    
    @IBOutlet var createdByLabel: UILabel!
    
    @IBOutlet var usernameBtn: UIButton!
    
    @IBOutlet var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
