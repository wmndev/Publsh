//
//  MagazineIntroductionCell.swift
//  publsh
//
//  Created by Itai Wiseman on 1/30/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class MagazineIntroductionCell: UITableViewCell {

    @IBOutlet var userProfileImage: UIImageView!
    
    @IBOutlet var collectedByLabel: UILabel!
    @IBOutlet var username: UIButton!
    @IBOutlet var magazineDescription: UILabel!
    
    @IBOutlet var pickMagazineButton: UIButton!
   
    @IBAction func pickMagazinePressed(sender: AnyObject) {
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
