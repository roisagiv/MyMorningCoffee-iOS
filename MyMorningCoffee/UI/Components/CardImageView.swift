//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
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
