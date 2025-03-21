//
//  SelectorTableViewCell.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!

    func updateElements(with title: String) {
        label.text = title
    }
}
