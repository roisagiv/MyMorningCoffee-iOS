//
//  CardImageView.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 18/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

class CardImageView: UIImageView {
  override func layoutSubviews() {
    super.layoutSubviews()
    curveImageToCorners()
  }

  func curveImageToCorners() {
    let roundingCorners = UIRectCorner.allCorners
    let bezierPath = UIBezierPath(roundedRect: bounds,
                                  byRoundingCorners: roundingCorners,
                                  cornerRadii: CGSize(width: 4,
                                                      height: 4))
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = bounds
    shapeLayer.path = bezierPath.cgPath
    layer.mask = shapeLayer
  }
}
