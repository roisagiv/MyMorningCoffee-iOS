//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation

extension NSObject {
  func associatedObject<T>(for key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(self, key) as? T
  }

  func setAssociatedObject<T>(_ object: T, for key: UnsafeRawPointer) {
    objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}
