//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import UIKit

struct Layout {
  static func apply(to layout: UICollectionViewFlowLayout) {
    layout.minimumLineSpacing = 80
    let size = CGSize(width: layout.collectionView?.bounds.width ?? 0, height: TopNewsCellView.height)
    layout.itemSize = size
  }
}
