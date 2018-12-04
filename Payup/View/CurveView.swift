//
//  CurveView.swift
//  Payup
//
//  Created by Ammar AlTahhan on 04/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

class CurveView: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = createBezierPath()
        
        let fillColor = UIColor.mainColor
        fillColor.setFill()
        path.fill()
    }
    
    func createBezierPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(withCenter: CGPoint(x: 80, y: -180), radius: 390, startAngle: CGFloat(Double.pi), endAngle: CGFloat(0), clockwise: false)
        path.close()
        
        return path
        
    }
    
}
