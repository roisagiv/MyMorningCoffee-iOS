//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import Reusable

class SplashSkeletonCellView: MDCCollectionViewCell, Reusable, NibLoadable {
  static let height: CGFloat = 9 * 32

  @IBOutlet private var favicon: UIView!
  @IBOutlet private var header: UIView!
  @IBOutlet private var cover: UIView!

  override func prepareForReuse() {
    super.prepareForReuse()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    Theme.apply(to: self)
    favicon.backgroundColor = Theme.placeHolderColor
    header.backgroundColor = Theme.placeHolderColor
    cover.backgroundColor = Theme.placeHolderColor
  }
}
