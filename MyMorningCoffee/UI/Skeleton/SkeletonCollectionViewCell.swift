//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import Skeleton
import UIKit

class SkeletonCollectionViewCell: MDCCollectionViewCell, SkeletonAnimatable {
  @IBOutlet var views: [GradientContainerView]!

  override func awakeFromNib() {
    super.awakeFromNib()

    let baseColor = Theme.placeHolderColor
    let nextColor = Theme.placeHolderDarkColor
    gradientLayers.forEach { gradientLayer in

      gradientLayer.colors = [baseColor.cgColor,
                              nextColor.cgColor,
                              baseColor.cgColor]
    }
  }

  var gradientLayers: [CAGradientLayer] {
    return views.map { $0.gradientLayer }
  }
}
