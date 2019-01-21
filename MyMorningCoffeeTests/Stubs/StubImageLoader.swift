//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

@testable import MyMorningCoffee
import UIKit

class StubImageLoader: ImageLoaderType {
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

  func clearCache() {
    // nothing
  }
}
