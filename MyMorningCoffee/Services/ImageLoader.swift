//
//  ImageLoader.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 11/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

protocol ImageLoader {
  func load(url: String?, imageView: UIImageView)
  func load(url: URL, imageView: UIImageView)
  func cancel(imageView: UIImageView)
}
