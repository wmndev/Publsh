//
//  MagazineIntroCell.swift
//  
//
//  Created by Itai Wiseman on 1/15/16.
//
//

import UIKit

class MagazineIntroCell: UITableViewCell {
    
    @IBOutlet var mImage: UIImageView!
    @IBOutlet var mTitle: UILabel!
    @IBOutlet var follow: UIButton!
    
    @IBOutlet var category1: UILabel!
    @IBOutlet var category2: UILabel!
    @IBOutlet var category3: UILabel!
    
    
    @IBAction func addMagazine(sender: AnyObject) {
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
