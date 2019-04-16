//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

// this code had been inspired by the example: https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Services/ActivityIndicator.swift
// Its License can be found here: ../DependenciesLicenses/RxSwift-License

import RxCocoa
import RxSwift

private struct ActivityToken<Element>: ObservableConvertibleType, Disposable {
  private let _source: Observable<Element>
  private let _dispose: Cancelable

  init(source: Observable<Element>, disposeAction: @escaping () -> Void) {
    _source = source
    _dispose = Disposables.create(with: disposeAction)
  }

  func dispose() {
    _dispose.dispose()
  }

  func asObservable() -> Observable<Element> {
    return _source
  }
}

/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class ActivityIndicator: SharedSequenceConvertibleType {
  // swiftlint:disable type_name
  public typealias E = Bool
  public typealias SharingStrategy = DriverSharingStrategy

  private let _lock = NSRecursiveLock()
  private let _relay = BehaviorRelay(value: 0)
  private let _loading: SharedSequence<SharingStrategy, Bool>

  public init() {
    _loading = _relay.asDriver()
      .map { $0 > 0 }
      .distinctUntilChanged()
  }

  fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
    return Observable.using({ () -> ActivityToken<O.E> in
      self.increment()
      return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
    }, observableFactory: { token in
      token.asObservable()
    })
  }

  private func increment() {
    _lock.lock()
    _relay.accept(_relay.value + 1)
    _lock.unlock()
  }

  private func decrement() {
    _lock.lock()
    _relay.accept(_relay.value - 1)
    _lock.unlock()
  }

  public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
    return _loading
  }
}

extension ObservableConvertibleType {
  public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
    return activityIndicator.trackActivityOfObservable(self)
  }
}
