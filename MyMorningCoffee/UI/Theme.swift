//
//  Theme.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import SwiftHEXColors

struct Theme {
  private let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
  private let typographyScheme = MDCTypographyScheme(defaults: .material201804)

  init() {
    colorScheme.primaryColor = UIColor(hex: 0xFFFFFF)!
    colorScheme.onPrimaryColor = UIColor(hex: 0x000000)!
    colorScheme.secondaryColor = UIColor(hex: 0x81D3F9)!
    colorScheme.onSecondaryColor = UIColor(hex: 0x000000)!

    let defaultTypography = MDCTypographyScheme()
    let fontName = "MontserratAlternates"
    typographyScheme.body1 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.body1.pointSize)!
    typographyScheme.body2 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.body2.pointSize)!
    typographyScheme.button = UIFont(name: "\(fontName)-Medium", size: defaultTypography.button.pointSize)!
    typographyScheme.caption = UIFont(name: "\(fontName)-Regular", size: defaultTypography.caption.pointSize)!
    typographyScheme.headline1 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline1.pointSize)!
    typographyScheme.headline2 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline2.pointSize)!
    typographyScheme.headline3 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline3.pointSize)!
    typographyScheme.headline4 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline4.pointSize)!
    typographyScheme.headline5 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline5.pointSize)!
    typographyScheme.headline6 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline6.pointSize)!
    typographyScheme.overline = UIFont(name: "\(fontName)-Medium", size: defaultTypography.overline.pointSize)!
    typographyScheme.subtitle1 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.subtitle1.pointSize)!
    typographyScheme.subtitle2 = UIFont(name: "\(fontName)-Medium", size: defaultTypography.subtitle2.pointSize)!
  }

  func apply(to appBar: MDCAppBarViewController) {
    MDCAppBarColorThemer.applyColorScheme(colorScheme, to: appBar)
    MDCAppBarTypographyThemer.applyTypographyScheme(typographyScheme, to: appBar)

    MDCNavigationBarColorThemer.applySemanticColorScheme(colorScheme, to: appBar.navigationBar)
    MDCNavigationBarTypographyThemer.applyTypographyScheme(typographyScheme, to: appBar.navigationBar)
  }

  func apply(to collectionView: UICollectionView?) {
    collectionView?.backgroundColor = colorScheme.backgroundColor
  }

  func apply(to cell: MDCCollectionViewTextCell) {
    cell.textLabel?.font = typographyScheme.subtitle1
    cell.detailTextLabel?.font = typographyScheme.subtitle2
  }
}
