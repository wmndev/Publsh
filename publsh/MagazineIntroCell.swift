//
//  MagazineIntroCell.swift
//  
//
//  Created by Itai Wiseman on 1/15/16.
//
//

import UIKit

class MagazineIntroCell: UITableViewCell {
    
    @IBOutlet var mDesc: UILabel!
    @IBOutlet var mImage: UIImageView!
    @IBOutlet var getBtn: UIButton!
    @IBOutlet var mTitle: UILabel!
    //@IBOutlet var category1: UILabel!


    //@IBOutlet var numOfFollowers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
