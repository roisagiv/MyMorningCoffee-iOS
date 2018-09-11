//
//  Images.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 15/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

class Images {
  static let placeholder: UIImage = imageWithColor(color: .gray)

  class func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(CGRect(origin: CGPoint.zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}
