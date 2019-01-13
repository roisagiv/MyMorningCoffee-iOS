//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import UIKit

protocol ImageLoaderType {
  func load(url: String?, imageView: UIImageView)
  func load(url: URL, imageView: UIImageView)
  func cancel(imageView: UIImageView)
  func clearCache()
}

import Nuke

class NukeImageLoader: ImageLoaderType {
  func load(url: String?, imageView: UIImageView) {
    imageView.image = nil
    guard let urlAsString = url, let imageUrl = URL(string: urlAsString) else {
      return
    }
    load(url: imageUrl, imageView: imageView)
    Nuke.ImageCache.shared.removeAll()
  }

  func load(url: URL, imageView: UIImageView) {
    cancel(imageView: imageView)
    Nuke.loadImage(
      with: url,
      options: ImageLoadingOptions(placeholder: Theme.placeHolderImage),
      into: imageView
    )
  }

  func cancel(imageView: UIImageView) {
    Nuke.cancelRequest(for: imageView)
    imageView.image = nil
  }

  func clearCache() {
    DataLoader.sharedUrlCache.removeAllCachedResponses()
    ImageCache.shared.removeAll()
  }
}
