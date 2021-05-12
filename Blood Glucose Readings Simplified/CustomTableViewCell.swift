//
//  CustomTableViewCell.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/12/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var tableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
