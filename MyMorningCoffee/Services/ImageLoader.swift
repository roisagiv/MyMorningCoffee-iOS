//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import UIKit

protocol ImageLoader {
  func load(url: String?, imageView: UIImageView)
  func load(url: URL, imageView: UIImageView)
  func cancel(imageView: UIImageView)
}
