//
//  MainTableViewCell.swift
//  Snubbble
//
//  Created by ViNiT. on 4/17/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var minsAgoLabel: UILabel!
    @IBOutlet var shotNameLabel: UILabel!
    @IBOutlet var gradientLayer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.gradientLayer.clipsToBounds = true
        
        let myGradientLayer = CAGradientLayer()
        myGradientLayer.frame = CGRectMake(0, 0, 1000, 90)
        myGradientLayer.colors = [UIColor(white: 0.0, alpha: 0.0).CGColor, UIColor(white: 0.0, alpha: 0.5).CGColor]
        
        self.gradientLayer.layer.addSublayer(myGradientLayer)
        
        //label modification
        shotNameLabel.textColor = UIColor.whiteColor()
        shotNameLabel.font = UIFont(name: FontPack.fontName, size: 18)
        minsAgoLabel.font = UIFont(name: FontPack.fontName, size: 13)
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor(white: 1, alpha: 1.0).CGColor
        profileImageView.layer.cornerRadius = 25
        profileImageView.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
