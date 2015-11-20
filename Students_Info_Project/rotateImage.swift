//
//  rotateImage.swift
//  homework2
//
//  Created by Weiqi Wei on 15/9/14.
//  Copyright (c) 2015年 Weiqi Wei. All rights reserved.
//

import UIKit

extension UIImage{
    public func imageRotationByDegrees(degrees: CGFloat)->UIImage{
        let degreesToRadians: (CGFloat)->CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0)
        CGContextRotateCTM(bitmap, degreesToRadians(degrees))
        CGContextScaleCTM(bitmap, 1.0, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
