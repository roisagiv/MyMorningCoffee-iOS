//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

// this code had been inspired by the project: https://github.com/devxoul/RxViewController
// Its License can be found here: ../DependenciesLicenses/devxoul-RxViewController-License

import UIKit.UIViewController

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
  /// Rx observable, triggered when the view has appeared for the first time
  public var firstTimeViewDidAppear: Single<Void> {
    return sentMessage(#selector(Base.viewDidAppear)).map { _ in Void() }.take(1).asSingle()
  }

  /// Rx observable, triggered when the view is being dismissed
  public var dismissed: ControlEvent<Bool> {
    let dismissedSource = sentMessage(#selector(Base.viewDidDisappear))
      .filter { [base] _ in base.isBeingDismissed }
      .map { _ in false }

    let movedToParentSource = sentMessage(#selector(Base.didMove))
      .filter({ !($0.first is UIViewController) })
      .map { _ in false }

    return ControlEvent(events: Observable.merge(dismissedSource, movedToParentSource))
  }

  /// Rx observable, triggered when the view appearance state changes
  public var displayed: Observable<Bool> {
    let viewDidAppearObservable = sentMessage(#selector(Base.viewDidAppear)).map { _ in true }
    let viewWillDisappearObservable = sentMessage(#selector(Base.viewWillDisappear)).map { _ in false }
    // a UIViewController is at first not displayed
    let initialState = Observable.just(false)
    // future calls to viewDidAppear and viewWillDisappear will chage the displayable state
    return initialState.concat(Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable))
  }
}
