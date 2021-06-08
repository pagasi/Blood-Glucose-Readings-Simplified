//
//  HeaderLabel.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 6/2/21.
//

import UIKit

class HeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.sandyBrownRGB
        layer.opacity = 1
        font = UIFont.boldSystemFont(ofSize: 15)
//        setTitle(title, for: .normal)

//        setTitleColor(.black, for: .normal)
        layer.borderWidth = 2
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
//        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
