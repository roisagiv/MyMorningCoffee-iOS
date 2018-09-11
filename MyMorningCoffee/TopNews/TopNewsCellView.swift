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
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var captionLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!

  static let height: CGFloat = 8 * 44

  func configure(item: TopNewsItem, imageLoader: ImageLoader?) {
    titleLabel.text = item.title
    Theme.apply(to: titleLabel, disabled: item.loading)

    descriptionLabel.text = item.description
    Theme.apply(to: descriptionLabel, disabled: item.loading)

    loadImage(loading: item.loading, url: item.cover, imageLoader: imageLoader)

    var captions: [String] = []
    if let source = item.source, source.isEmpty == false {
      captions.append(source)
    }

    if let published = item.publishedAt {
      let date = moment(published)
      captions.append(date.fromNow())
    }
    if let author = item.author, author.isEmpty == false {
      captions.append(author)
    }

    captionLabel.text = captions.joined(separator: " · ")
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
    coverImageView.image = nil
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    Theme.apply(to: self)
    Theme.apply(.subtitle1, to: titleLabel)
    Theme.apply(.body2, to: descriptionLabel)
    Theme.apply(.caption, to: captionLabel)
  }
}
