//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import SwiftHEXColors
import WebKit

struct Theme {
  enum Typography {
    case body1
    case body2
    case button
    case caption
    case overline
    case subtitle1
    case subtitle2
    case headline5
    case headline6
  }

  private enum Color: Int {
    case primary = 0xFFFFFF
//    case primaryLight = 0xFFFFFF
    case primaryDark = 0xCCCCCC
    case secondary = 0x81D3F9
    case secondaryLight = 0xB5FFFF
    case secondaryDark = 0x4BA2C6
    case black = 0x000000
    case placeHolder = 0xF2F2F2
    case placeHolderDark = 0xE5E5E5

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
    colorScheme.surfaceColor = Color.primary.asUIColor()
    colorScheme.backgroundColor = Color.primary.asUIColor()
    colorScheme.onPrimaryColor = Color.black.asUIColor()
    colorScheme.onSecondaryColor = Color.black.asUIColor()
    colorScheme.onBackgroundColor = Color.black.asUIColor()
    colorScheme.onSurfaceColor = Color.black.asUIColor()

    let defaultTypography: MDCTypographyScheme = MDCTypographyScheme()
    let fontName: String = "Nunito"
    typographyScheme.body1 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.body1.pointSize)!
    typographyScheme.body2 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.body2.pointSize)!
    typographyScheme.button = UIFont(name: "\(fontName)-SemiBold", size: defaultTypography.button.pointSize)!
    typographyScheme.caption = UIFont(name: "\(fontName)-Regular", size: defaultTypography.caption.pointSize)!
    typographyScheme.headline1 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline1.pointSize)!
    typographyScheme.headline2 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline2.pointSize)!
    typographyScheme.headline3 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline3.pointSize)!
    typographyScheme.headline4 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline4.pointSize)!
    typographyScheme.headline5 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline5.pointSize)!
    typographyScheme.headline6 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.headline6.pointSize)!
    typographyScheme.overline = UIFont(name: "\(fontName)-SemiBold", size: defaultTypography.overline.pointSize)!
    typographyScheme.subtitle1 = UIFont(name: "\(fontName)-Regular", size: defaultTypography.subtitle1.pointSize)!
    typographyScheme.subtitle2 = UIFont(name: "\(fontName)-SemiBold", size: defaultTypography.subtitle2.pointSize)!
    MDCIcons.ic_arrow_backUseNewStyle(true)
  }

  static var tintTextColor: UIColor = Color.secondary.asUIColor()

  static var textColor: UIColor = Color.black.asUIColor()

  static var placeHolderImage: UIImage = Images.imageWithColor(color: Color.placeHolder.asUIColor())
  static var placeHolderColor: UIColor = Color.placeHolder.asUIColor()
  static var placeHolderDarkColor: UIColor = Color.placeHolderDark.asUIColor()

  static func apply(to appBar: MDCAppBarViewController) {
    MDCAppBarColorThemer.applyColorScheme(colorScheme, to: appBar)
    MDCAppBarTypographyThemer.applyTypographyScheme(typographyScheme, to: appBar)

    MDCNavigationBarColorThemer.applySemanticColorScheme(colorScheme, to: appBar.navigationBar)
    MDCNavigationBarTypographyThemer.applyTypographyScheme(typographyScheme, to: appBar.navigationBar)

    appBar.headerView.minMaxHeightIncludesSafeArea = false
    appBar.isTopLayoutGuideAdjustmentEnabled = true
  }

  static func apply(to viewController: UIViewController) {
    viewController.view.backgroundColor = colorScheme.backgroundColor
  }

  static func apply(to collectionView: UICollectionView?) {
    collectionView?.backgroundColor = colorScheme.backgroundColor
  }

  static func apply(to cell: MDCCollectionViewTextCell) {
    cell.backgroundColor = colorScheme.surfaceColor
    cell.tintColor = colorScheme.onPrimaryColor

    if let textLabel = cell.textLabel {
      apply(.subtitle1, to: textLabel)
      textLabel.textColor = colorScheme.onSurfaceColor
    }

    if let detailTextLabel = cell.detailTextLabel {
      apply(.body2, to: detailTextLabel)
      detailTextLabel.textColor = colorScheme.onSurfaceColor.withAlphaComponent(0.5)
    }
  }

  static func apply(to cell: MDCCardCollectionCell) {
    cell.setShadowElevation(ShadowElevation(rawValue: 0), for: .normal)
    cell.setShadowElevation(ShadowElevation(rawValue: 0), for: .highlighted)
    cell.setShadowElevation(ShadowElevation(rawValue: 0), for: .selected)
    cell.backgroundColor = colorScheme.backgroundColor
    cell.inkView.inkColor = .clear
  }

  static func apply(to cell: UICollectionViewCell) {
    cell.backgroundColor = colorScheme.surfaceColor
  }

  static func apply(to webView: WKWebView) {
    webView.backgroundColor = colorScheme.backgroundColor
  }

  static func apply(to toggle: UISwitch) {
    toggle.onTintColor = colorScheme.secondaryColor
  }

  static func apply(to progressView: MDCProgressView) {
    progressView.trackTintColor = colorScheme.primaryColor
    progressView.progressTintColor = colorScheme.secondaryColor
  }

  static func apply(to activityIndicator: MDCActivityIndicator) {
    activityIndicator.cycleColors = [colorScheme.secondaryColor]
  }

  static func apply(to label: UILabel, disabled: Bool = false) {
    let alpha: CGFloat = disabled ? 0.43 : 1.0
    label.textColor = Color.black.asUIColor().withAlphaComponent(alpha)
  }

  static func apply(_ typography: Typography, to label: UILabel, alpha: CGFloat = 1) {
    label.font = font(of: typography)
    label.textColor = Color.black.asUIColor().withAlphaComponent(alpha)
  }

  static func apply(_ typography: Typography, to textView: UITextView, alpha: CGFloat = 1) {
    textView.font = font(of: typography)
    textView.textColor = Color.black.asUIColor().withAlphaComponent(alpha)
  }

  private static func font(of typography: Typography) -> UIFont {
    var font: UIFont
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
    case .headline5:
      font = typographyScheme.headline5
    case .headline6:
      font = typographyScheme.headline6
    }
    return font
  }
}
