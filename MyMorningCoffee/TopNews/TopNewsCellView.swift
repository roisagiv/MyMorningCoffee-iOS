//
//  TopNewsCellView.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 18/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import Reusable
import SwiftMoment

final class TopNewsCellView: MDCCardCollectionCell, Reusable, NibLoadable {
  @IBOutlet private var coverImageView: UIImageView!
  @IBOutlet private var faviconImageView: UIImageView!
  @IBOutlet private var sourceLabel: UILabel!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var captionLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!

  static let height: CGFloat = 8 * 50

  func configure(item: TopNewsItem, imageLoader: ImageLoader?, formatter: Formatter?) {
    titleLabel.text = item.title
    Theme.apply(to: titleLabel, disabled: item.loading)

    descriptionLabel.text = item.description
    Theme.apply(to: descriptionLabel, disabled: item.loading)

    loadImage(loading: item.loading, url: item.cover, imageLoader: imageLoader)

    if let source = item.source, source.isEmpty == false {
      sourceLabel.text = source
      imageLoader?.load(url: item.sourceFavicon, imageView: faviconImageView)
    }

    if let published = item.publishedAt, let formatter = formatter {
      captionLabel.text = formatter.relativeFromNow(date: published)
    }

    Theme.apply(to: captionLabel, disabled: item.loading)
  }

  private func loadImage(loading: Bool, url: String?, imageLoader: ImageLoader?) {
    guard loading == false, let url = url, let imageUrl = URL(string: url) else {
      coverImageView.image = Images.imageWithColor(color: Theme.placeholderColor)
      return
    }
    imageLoader?.load(url: imageUrl, imageView: coverImageView)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    captionLabel.text = nil
    descriptionLabel.text = nil
    sourceLabel.text = nil
    coverImageView.image = nil
    faviconImageView.image = nil
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    Theme.apply(to: self)
    Theme.apply(.headline6, to: titleLabel)
    Theme.apply(.body2, to: descriptionLabel)
    Theme.apply(.caption, to: captionLabel)
    Theme.apply(.caption, to: sourceLabel)
  }
}
