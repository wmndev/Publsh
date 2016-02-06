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
    @IBOutlet var mDescription: UILabel!
    @IBOutlet var filter1: UIButton!
    @IBOutlet var filter2: UIButton!
    @IBOutlet var filter3: UIButton!
    @IBOutlet var follow: UIButton!
    
    @IBAction func filter(sender: AnyObject) {
        
    }
    
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
