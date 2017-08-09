//
//  FancyBtn.swift
//  JTSocialMedia
//
//  Created by Jiří Tomis on 09.08.17.
//  Copyright © 2017 JT. All rights reserved.
//

import UIKit

class FancyBtn: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
        layer.cornerRadius = 2.0
        
    }
}
