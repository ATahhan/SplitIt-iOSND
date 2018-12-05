//
//  Color.swift
//  CSVA
//
//  Created by Ammar AlTahhan on 01/07/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var whiteBackground: UIColor {
        return UIColor(rgb: 0xF6F6F6)
    }
    
    class var whiteContent: UIColor {
        return whiteBackground
    }
    
    class var lightGreyBackground: UIColor {
        return UIColor(rgb: 0xEDEDED)
    }
    
    class var blackContent: UIColor {
        return UIColor(rgb: 0x232323)
    }
    
    /// Hex = 0x909090
    class var greyContent: UIColor {
        return UIColor(rgb: 0x909090)
    }
    
    class var lightGreyContent: UIColor {
        return UIColor(rgb: 0xCFCFCF)
    }
    
    static var mainColor: UIColor = UIColor(rgb: 0x699CD9)
    
    class var darkMainColor: UIColor {
        return UIColor(rgb: 0x325379)
    }
    
    class var correctGreen: UIColor {
        return UIColor(rgb: 0x32C732)
    }
    
    class var wrongRed: UIColor {
        return UIColor(rgb: 0xC65D14)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
