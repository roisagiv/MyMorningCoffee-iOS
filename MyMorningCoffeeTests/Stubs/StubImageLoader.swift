//
//  StubImageLoader.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 11/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

@testable import MyMorningCoffee
import UIKit

class StubImageLoader: ImageLoader {
  func load(url: String?, imageView: UIImageView) {
    guard let url = url else {
      imageView.image = Images.imageWithColor(color: .red)
      return
    }
    guard let imageUrl = URL(string: url) else {
      imageView.image = Images.imageWithColor(color: .red)
      return
    }
    load(url: imageUrl, imageView: imageView)
  }

  func load(url _: URL, imageView: UIImageView) {
    imageView.image = Images.imageWithColor(color: .green)
  }

  func cancel(imageView: UIImageView) {
    imageView.image = nil
  }
}
