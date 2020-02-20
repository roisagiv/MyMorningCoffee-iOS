//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import TinyConstraints
import Reusable

class SplashSkeletonCellView2: UICollectionViewCell, Reusable {
  static let height: CGFloat = 9 * 32

  private let favicon: UIView = {
    let view = UIView()
    view.backgroundColor = Theme.placeHolderColor
    return view
  }()

  private let header: UIView = {
    let view = UIView()
    view.backgroundColor = Theme.placeHolderColor
    return view
  }()
  
  private var cover: UIView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(favicon)
    favicon.height(24)
    favicon.widthToHeight(of: favicon)
    favicon.leftToSuperview()
    favicon.topToSuperview()

    addSubview(header)
    header.height(to: favicon, multiplier: 0.4)
    header.left(to: favicon, offset: -8)
    header.rightToSuperview()
    header.centerY(to: favicon)
  }

  required init?(coder _: NSCoder) {
    fatalError("Do not support storyboard")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    Theme.apply(to: self)
  }
}
