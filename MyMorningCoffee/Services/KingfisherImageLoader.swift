//
//  KingFisherImageLoader.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 11/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Kingfisher

class KingfisherImageLoader: ImageLoader {
  func cancel(imageView: UIImageView) {
    imageView.kf.cancelDownloadTask()
    imageView.image = nil
  }

  func load(url: String?, imageView: UIImageView) {
    guard let url = url, let imageUrl = URL(string: url) else {
      imageView.image = nil
      return
    }
    load(url: imageUrl, imageView: imageView)
  }

  func load(url: URL, imageView: UIImageView) {
    imageView.kf.setImage(with: url)
  }
}
