//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
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
  @IBOutlet private var headerView: UIView!

  static let height: CGFloat = 8 * 50

  private var imageLoader: ImageLoaderType?

  func configure(item: TopNewsItem, imageLoader: ImageLoaderType?) {
    self.imageLoader = imageLoader

    titleLabel.text = item.title
    Theme.apply(to: titleLabel, disabled: item.loading)

    descriptionLabel.text = item.description
    Theme.apply(to: descriptionLabel, disabled: item.loading)

    loadImage(loading: item.loading, url: item.cover, imageLoader: imageLoader)

    if let source = item.source, source.isEmpty == false {
      headerView.alpha = 1
      sourceLabel.text = source
      imageLoader?.load(url: item.sourceFavicon, imageView: faviconImageView)
    } else {
      headerView.alpha = 0
    }

    if let published = item.publishedAtRelative {
      captionLabel.text = published
    }

    Theme.apply(to: captionLabel, disabled: item.loading)
  }

  private func loadImage(loading: Bool, url: String?, imageLoader: ImageLoaderType?) {
    guard loading == false, let url = url, let imageUrl = URL(string: url) else {
      coverImageView.image = Theme.placeHolderImage
      return
    }
    imageLoader?.load(url: imageUrl, imageView: coverImageView)
  }

  private func clear() {
    titleLabel.text = nil
    captionLabel.text = nil
    descriptionLabel.text = nil
    sourceLabel.text = nil
    coverImageView.image = nil
    faviconImageView.image = nil
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    clear()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    clear()

    Theme.apply(to: self)
    Theme.apply(.headline6, to: titleLabel)
    Theme.apply(.body2, to: descriptionLabel)
    Theme.apply(.caption, to: captionLabel)
    Theme.apply(.caption, to: sourceLabel)

    imageLoader?.cancel(imageView: coverImageView)
    imageLoader?.cancel(imageView: faviconImageView)
  }
}
