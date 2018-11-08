//
//  NukeImageLoader.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 10/11/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Nuke

class NukeImageLoader: ImageLoader {
  func load(url: String?, imageView: UIImageView) {
    imageView.image = nil
    guard let urlAsString = url, let imageUrl = URL(string: urlAsString) else {
      return
    }
    load(url: imageUrl, imageView: imageView)
  }

  func load(url: URL, imageView: UIImageView) {
    imageView.image = nil
    Nuke.loadImage(with: url, into: imageView)
  }

  func cancel(imageView: UIImageView) {
    Nuke.cancelRequest(for: imageView)
    imageView.image = nil
  }
}
