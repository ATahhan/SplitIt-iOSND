//
//  MainButton.swift
//  Payup
//
//  Created by Ammar AlTahhan on 04/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

class MainButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.mainColor
        setTitleColor(UIColor.whiteContent, for: .normal)
        cornerRadius = 12
    }

}
