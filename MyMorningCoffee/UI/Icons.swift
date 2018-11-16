//
//  Icons.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/11/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialDesignSymbol

struct Icons {
  static func settings(size: CGSize) -> UIImage {
    return image(
      from: MaterialDesignIcon.settings48px,
      size: size,
      color: Theme.tintTextColor
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
