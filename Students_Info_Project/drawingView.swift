//
//  drawingView.swift
//  HaoLi_590roster
//
//  Created by HAO LI on 9/14/15.
//  Copyright (c) 2015 HAO LI. All rights reserved.
//

import UIKit



class drawingView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        // gradients
        let con1 = UIGraphicsGetCurrentContext()
        CGContextSetShadow(con1, CGSizeMake(10, 10), 8) // shadow
        
        CGContextSaveGState(con1)
        CGContextMoveToPoint(con1, 90, 100)
        CGContextAddLineToPoint(con1, 100, 90)
        CGContextAddLineToPoint(con1, 110, 100)
        CGContextClosePath(con1)
        CGContextAddRect(con1, CGContextGetClipBoundingBox(con1))
        CGContextEOClip(con1)
        CGContextMoveToPoint(con1, 100, 100)
        CGContextAddLineToPoint(con1, 100, 19)
        CGContextSetLineWidth(con1, 20)
        CGContextReplacePathWithStrokedPath(con1)
        CGContextClip(con1)
        let locs : [CGFloat] = [0.0, 0.5, 1.0]
        let colors : [CGFloat] = [
            0.3, 0.3, 0.3, 0.8,
            0.0, 0.0, 0.0, 1.0,
            0.3, 0.3, 0.3, 0.8
        ]
        let sp = CGColorSpaceCreateDeviceGray()
        let grad1 = CGGradientCreateWithColorComponents(sp, colors, locs, 3)
        CGContextDrawLinearGradient(con1, grad1, CGPointMake(89, 0), CGPointMake(111, 0), CGGradientDrawingOptions(rawValue: 0))
        CGContextRestoreGState(con1)
        CGContextSetFillColorWithColor(con1, UIColor.redColor().CGColor)
        CGContextMoveToPoint(con1, 80, 25)
        CGContextAddLineToPoint(con1, 100, 0)
        CGContextAddLineToPoint(con1, 120, 25)
        CGContextFillPath(con1)
    }
    

}
