//
//  MagazineIntroDetails.swift
//  publsh
//
//  Created by Itai Wiseman on 1/15/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class MagazineIntroDetails: UITableViewCell {

    @IBOutlet var magazineDescription: UILabel!
    @IBOutlet var username: UIButton!
    @IBOutlet var readersButton: UIButton!
    
    @IBAction func usernameClick(sender: AnyObject) {
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
