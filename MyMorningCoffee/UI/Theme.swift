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
  enum Typography {
    case body1
    case body2
    case button
    case caption
    case overline
    case subtitle1
    case subtitle2
  }

  private enum Color: Int {
    case primary = 0xF5F5F6
    case primaryLight = 0xFFFFFF
    case primaryDark = 0xC2C2C3
    case secondary = 0x81D3F9
    case secondaryLight = 0xB5FFFF
    case secondaryDark = 0x4BA2C6
    case black = 0x000000

    func asUIColor() -> UIColor {
      return UIColor(hex: rawValue)!
    }
  }

  private static let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
  private static let typographyScheme = MDCTypographyScheme(defaults: .material201804)

  static func configure() {
    colorScheme.primaryColor = Color.primary.asUIColor()
    colorScheme.primaryColorVariant = Color.primaryDark.asUIColor()
    colorScheme.secondaryColor = Color.secondary.asUIColor()
    colorScheme.surfaceColor = Color.primaryLight.asUIColor()
    colorScheme.backgroundColor = Color.primary.asUIColor()
    colorScheme.onPrimaryColor = Color.black.asUIColor()
    colorScheme.onSecondaryColor = Color.black.asUIColor()
    colorScheme.onBackgroundColor = Color.black.asUIColor()
    colorScheme.onSurfaceColor = Color.black.asUIColor()

    let defaultTypography: MDCTypographyScheme = MDCTypographyScheme()
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

  static var placeholderColor: UIColor = Color.primary.asUIColor()

  static func apply(to appBar: MDCAppBarViewController) {
    MDCAppBarColorThemer.applyColorScheme(colorScheme, to: appBar)
    MDCAppBarTypographyThemer.applyTypographyScheme(typographyScheme, to: appBar)

    MDCNavigationBarColorThemer.applySemanticColorScheme(colorScheme, to: appBar.navigationBar)
    MDCNavigationBarTypographyThemer.applyTypographyScheme(typographyScheme, to: appBar.navigationBar)
  }

  static func apply(to collectionView: UICollectionView?) {
    collectionView?.backgroundColor = colorScheme.backgroundColor
  }

  static func apply(to cell: MDCCollectionViewTextCell) {
    cell.textLabel?.font = typographyScheme.subtitle1
    cell.detailTextLabel?.font = typographyScheme.subtitle2
  }

  static func apply(to cell: MDCCardCollectionCell) {
    cell.setShadowElevation(ShadowElevation(rawValue: 0), for: .normal)
    cell.setShadowElevation(ShadowElevation(rawValue: 0), for: .highlighted)
    cell.setShadowElevation(ShadowElevation(rawValue: 0), for: .selected)
    cell.inkView.inkColor = .clear
  }

  static func apply(to label: UILabel, disabled: Bool = false) {
    let alpha: CGFloat = disabled ? 0.43 : 1.0
    label.textColor = Color.black.asUIColor().withAlphaComponent(alpha)
  }

  static func apply(_ typography: Typography, to label: UILabel, alpha: CGFloat = 1) {
    var font: UIFont = label.font
    switch typography {
    case .body1:
      font = typographyScheme.body1
    case .body2:
      font = typographyScheme.body2
    case .button:
      font = typographyScheme.button
    case .caption:
      font = typographyScheme.caption
    case .overline:
      font = typographyScheme.overline
    case .subtitle1:
      font = typographyScheme.subtitle1
    case .subtitle2:
      font = typographyScheme.subtitle2
    }
    label.font = font
    label.textColor = Color.black.asUIColor().withAlphaComponent(alpha)
  }
}
