//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialDesignSymbol

struct Icons {
  private static let defaultSize = CGSize(width: 24, height: 24)
  private static let defaultColor = Theme.textColor

  static func settings(size: CGSize = defaultSize, color: UIColor = defaultColor) -> UIImage {
    return image(
      from: MaterialDesignIcon.settings48px,
      size: size,
      color: color
    )
  }

  static func moreOptions(size: CGSize = defaultSize, color: UIColor = defaultColor) -> UIImage {
    return image(
      from: MaterialDesignIcon.moreHoriz48px,
      size: size,
      color: color
    )
  }

  static func openWith(size: CGSize = defaultSize, color: UIColor = defaultColor) -> UIImage {
    return image(
      from: MaterialDesignIcon.launch48px,
      size: size,
      color: color
    )
  }

  private static func image(from text: String, size: CGSize, color: UIColor) -> UIImage {
    let symbol: MaterialDesignSymbol = MaterialDesignSymbol(
      text: text,
      size: size.width
    )
    symbol.addAttribute(
      attributeName: NSAttributedStringKey.foregroundColor,
      value: color
    )
    return symbol.image(size: size)
  }
}
