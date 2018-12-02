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
    
    class var mainRed: UIColor {
        return UIColor(rgb: 0xC61A14)
    }
    
    static var mainColor: UIColor = UIColor(rgb: 0xf45661) 
    
    class var correctGreen: UIColor {
        return UIColor(rgb: 0x32C732)
    }
    
    class var wrongRed: UIColor {
        return mainRed
    }
    
    class var moocRed: UIColor {
        return mainRed
    }
    
    class var liveBlue: UIColor {
        return UIColor(rgb: 0x1479C6)
    }
    
    class var ratingStarYellowFill: UIColor {
        return UIColor(rgb: 0xF8EC5F)
    }
    
    class var ratingStarYellowBorder: UIColor {
        return UIColor(rgb: 0xF1E660)
    }
    
    class var greenScore: UIColor {
        return UIColor(rgb: 0xafd136)
    }
    
    class var silverScore: UIColor {
        return UIColor(rgb: 0xa6a6a6)
    }
    
    class var goldScore: UIColor {
        return UIColor(rgb: 0xB8860B)
    }
    
    class var platinumScore: UIColor {
        return UIColor(rgb: 0x6a420c)
    }
    
    class var diamondScore: UIColor {
        return UIColor(rgb: 0x730c16)
    }
    
    class var vipScore: UIColor {
        return UIColor(rgb: 0xafd136)
    }
    
    class var examsContentYellow: UIColor {
        return UIColor(rgb: 0xFFC107)
    }
    
    class var assignmentsContentTurquoise: UIColor {
        return UIColor(rgb: 0x00BCD4)
    }
    
    class var virtualContentCyan: UIColor {
        return UIColor(rgb: 0x00BCD4)
    }
    
    class var materialContentOrange: UIColor {
        return UIColor(rgb: 0xFF9800)
    }
    
    class var videosContentLightGreen: UIColor {
        return UIColor(rgb: 0xFF9800)
    }
    
    class var youtubeContentRed: UIColor {
        return UIColor(rgb: 0xFF0601)
    }
    
    class var vimeoContentBlue: UIColor {
        return UIColor(rgb: 0x00ADEF)
    }
    
    class var documentContentOrange: UIColor {
        return materialContentOrange
    }
    
    class var imagesContentGreen: UIColor {
        return UIColor(rgb: 0x7FC400)
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
