//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import Reusable
import Skeleton

class SplashSkeletonCellView: SkeletonCollectionViewCell, Reusable, NibLoadable {
  static let height: CGFloat = 8 * 32

  override func prepareForReuse() {
    super.prepareForReuse()
    stopAnimation()
  }
}
