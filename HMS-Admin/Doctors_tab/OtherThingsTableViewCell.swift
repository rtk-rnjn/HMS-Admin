//
//  OtherThingsTableViewCell.swift
//  HMS-Admin
//
//  Created by Vibhav Upadhyay on 26/03/25.
//

import UIKit

class OtherThingsTableViewCell: UITableViewCell {
    
    @IBOutlet var imagView: UIImageView!
    
    
    @IBOutlet var upperLabel: UILabel!
    
    @IBOutlet var lowerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
