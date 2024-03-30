//
//  UIImageExtension.swift
//  GaoDeMapDemo
//
//  Created by cc on 2024/3/29.
//

import UIKit
import CoreGraphics

extension UIImage {
    class func imageWithColor(color: UIColor, rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
