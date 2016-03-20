//
//  SimpleObjectCell.swift
//  publsh
//
//  Created by Itai Wiseman on 3/19/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class SimpleObjectCell: UITableViewCell {

    @IBOutlet var objName: UILabel!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var followBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
