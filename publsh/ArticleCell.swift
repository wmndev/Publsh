//
//  ArticleCell.swift
//  publsh
//
//  Created by Itai Wiseman on 3/11/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet var aSourceImg: UIImageView!
    @IBOutlet var aSubTitle: UILabel!
    @IBOutlet var aTitle: UILabel!
    @IBOutlet var aImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
