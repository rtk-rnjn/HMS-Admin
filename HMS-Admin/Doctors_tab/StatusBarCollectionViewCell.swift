//
//  StatusBarCollectionViewCell.swift
//  HMS-Admin
//
//  Created by harsh chauhan on 26/03/25.
//

import UIKit

class StatusBarCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var doctorStatusImage: UIImageView!
    
    @IBOutlet var doctorCountLabel: UILabel!
    
    @IBOutlet var doctorStatusLabel: UILabel!
    
    
    func update(with indexPath: IndexPath){
        doctorStatusLabel.layer.opacity = 0.6
        switch indexPath.row {
        case 1:
            doctorStatusLabel.text = "Active"
            doctorStatusImage.image = UIImage(systemName: "checkmark.circle")
            doctorStatusImage.tintColor = .systemGreen
            
        case 2:
            doctorStatusLabel.text = "On Leave"
            doctorStatusImage.image = UIImage(systemName: "moon.fill")
            doctorStatusImage.tintColor = .systemOrange
        default:return
        }
    }
    
}
