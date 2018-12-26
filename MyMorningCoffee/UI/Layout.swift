//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import UIKit

struct Layout {
  static func apply(to layout: UICollectionViewFlowLayout) {
    layout.minimumLineSpacing = 64
    let width = layout.collectionView?.bounds.width ?? 0
    let size = CGSize(width: width - 16, height: TopNewsCellView.height)
    layout.itemSize = size
  }
}
