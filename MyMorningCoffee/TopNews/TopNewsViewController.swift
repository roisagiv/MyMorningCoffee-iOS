//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import RxCocoa
import RxDataSources
import RxSwift
import RxSwiftExt
import UIKit

class TopNewsViewController: UICollectionViewController {
  typealias TopNewsItemModel = SectionModel<String, TopNewsItem>
  private static let sectionHeader = "Items"

  fileprivate let appBar = MDCAppBarViewController()
  private let activityIndicator = MDCActivityIndicator()

  private let disposeBag = DisposeBag()
  fileprivate var viewModel: TopNewsViewModelType?
  fileprivate var imageLoader: ImageLoaderType?
  fileprivate var router: Router?
  private let scrollIdleSubject = BehaviorSubject<Bool>(value: true)

  // swiftlint:disable function_body_length
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppBar()
    setupCollectionView()

    if let collectionView = collectionView, let viewModel = viewModel {
      let indexToFetch = Observable.merge(
        collectionView.rx.prefetchItems.asObservable(),
        collectionView.rx.willDisplayCell.map { [$1] }.asObservable()
      )

      indexToFetch.distinctUntilChanged()
        .withLatestFrom(viewModel.items.asObservable()) { ($0, $1) }
        .filter { $0.0.isNotEmpty }
        .pausableBuffered(scrollIdleSubject, limit: 5)
        .flatMap { indexPaths, items in
          Driver.from(indexPaths.map { $0.row }.map { items[$0].id })
        }
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: 0)
        .drive(viewModel.loadItem.inputs)
        .disposed(by: disposeBag)

      collectionView.rx.modelSelected(TopNewsItem.self)
        .subscribe(onNext: { [unowned self] item in
          if let urlAsString = item.url, let url = URL(string: urlAsString) {
            self.router?.navigate(to: .item(url: url, title: item.title), from: self.navigationController)
          }
        })
        .disposed(by: disposeBag)

      Observable.merge(collectionView.rx.willBeginDragging.asObservable(),
                       collectionView.rx.didEndDragging.filter { $0 == true }.map { _ in () })
        .map { false }
        .bind(to: scrollIdleSubject)
        .disposed(by: disposeBag)

      Observable.merge(collectionView.rx.didEndScrollingAnimation.asObservable(),
                       collectionView.rx.didEndDecelerating.asObservable(),
                       collectionView.rx.didEndDragging.filter { $0 == false }.map { _ in () }.asObservable())
        .map { true }
        .bind(to: scrollIdleSubject)
        .disposed(by: disposeBag)

      Driver.merge(
        Driver.combineLatest(rx.displayed.asDriver(onErrorJustReturn: false), viewModel.items)
          .filter { displayed, items in
            items.isEmpty && displayed
          }.map { _, _ in () },
        rx.firstTimeViewDidAppear.asDriver(onErrorJustReturn: ())
      )
      .drive(viewModel.refresh.inputs)
      .disposed(by: disposeBag)
    }
  }

  private func setupCollectionView() {
    Theme.apply(to: collectionView)

    collectionView?.register(cellType: TopNewsCellView.self)
    collectionView?.register(cellType: SplashSkeletonCellView.self)

    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      Layout.apply(to: layout)
    }
    collectionView?.dataSource = nil

    let dataSource = RxCollectionViewSectionedReloadDataSource<TopNewsItemModel>(
      configureCell: { [unowned self] _, collectionView, indexPath, item in
        if item.loading {
          let cell: SplashSkeletonCellView = collectionView.dequeueReusableCell(for: indexPath)
          return cell
        } else {
          let cell: TopNewsCellView = collectionView.dequeueReusableCell(for: indexPath)
          cell.configure(item: item, imageLoader: self.imageLoader)
          return cell
        }
      }
    )
    if let collectionView = collectionView, let viewModel = viewModel {
      viewModel.items
        .throttle(0.1, latest: true)
        .do(onNext: { [unowned self] items in
          if items.isEmpty {
            self.activityIndicator.startAnimating()
          } else {
            self.activityIndicator.stopAnimating()
          }
        })
        .map {
          [TopNewsItemModel(model: TopNewsViewController.self.sectionHeader, items: $0)]
        }
        .drive(collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
  }

  private func setupAppBar() {
    navigationItem.title = "Top News"

    view.addSubview(appBar.view)
    appBar.headerView.trackingScrollView = collectionView
    addChild(appBar)
    appBar.didMove(toParent: self)

    Theme.apply(to: activityIndicator)
    activityIndicator.sizeToFit()
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicator)
    activityIndicator.centerXAnchor.constraint(
      equalTo: view.centerXAnchor
    ).isActive = true
    activityIndicator.centerYAnchor.constraint(
      equalTo: view.centerYAnchor
    ).isActive = true

    let settingsButton = UIBarButtonItem(
      image: Icons.settings(size: CGSize(width: 24, height: 24)),
      style: .plain,
      target: self,
      action: #selector(settingsButtonClicked)
    )
    appBar.navigationBar.rightBarButtonItem = settingsButton
    Theme.apply(to: appBar)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  @objc private func settingsButtonClicked() {
    router?.navigate(to: .settings, from: navigationController)
  }
}

extension TopNewsViewController {}

extension TopNewsViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerView.trackingScrollView {
      appBar.headerView.trackingScrollDidScroll()
    }
  }

  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerView.trackingScrollView {
      appBar.headerView.trackingScrollDidEndDecelerating()
    }
  }

  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView == appBar.headerView.trackingScrollView {
      let headerView = appBar.headerView
      headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
    }
  }

  override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    if scrollView == appBar.headerView.trackingScrollView {
      let headerView = appBar.headerView
      headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
  }

  override var childForStatusBarStyle: UIViewController? {
    return appBar
  }

  override var childForStatusBarHidden: UIViewController? {
    return appBar
  }
}

extension TopNewsViewController {
  class func create(
    viewModel: TopNewsViewModelType,
    imageLoader: ImageLoaderType,
    router: Router
  ) -> TopNewsViewController {
    let vc = TopNewsViewController(collectionViewLayout: UICollectionViewFlowLayout())
    vc.viewModel = viewModel
    vc.imageLoader = imageLoader
    vc.router = router
    return vc
  }
}
