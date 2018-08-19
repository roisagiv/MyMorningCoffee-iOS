//
//  TopNewsCellView.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 18/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Kingfisher
import MaterialComponents
import Reusable
import SwiftMoment

class TopNewsCellView: MDCCardCollectionCell, Reusable, NibLoadable {
  @IBOutlet private var coverImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var sourceLabel: UILabel!
  @IBOutlet private var publishedAtLabel: UILabel!

  static let height: CGFloat = 8 * 38

  func configure(item: TopNewsItem) {
    titleLabel.text = item.title
    sourceLabel.text = item.source
    if let cover = item.cover {
      let url = URL(string: cover)
      coverImageView.kf.setImage(with: url)
    }

    if let published = item.publishedAt {
      let date = moment(published)
      publishedAtLabel.text = "\(date.fromNow()) · \(item.author ?? "")"
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    coverImageView.kf.cancelDownloadTask()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    Theme.apply(to: self)
    Theme.apply(.subtitle1, to: titleLabel)
    Theme.apply(.caption, to: sourceLabel)
    Theme.apply(.subtitle2, to: publishedAtLabel)
  }
}
