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
import UIKit

class TopNewsViewController: UICollectionViewController {
  typealias TopNewsItemModel = SectionModel<String, TopNewsItem>

  fileprivate let appBar = MDCAppBarViewController()
  private let activityIndicator = MDCActivityIndicator()

  private let disposeBag = DisposeBag()
  fileprivate var viewModel: TopNewsViewModelType?
  fileprivate var imageLoader: ImageLoader?
  fileprivate var router: Router?
  fileprivate var formatter: Formatter?
  private let scrollIdleSubject = BehaviorSubject<Bool>(value: true)

  override func viewDidLoad() {
    super.viewDidLoad()

    Theme.apply(to: collectionView)
    setupAppBar()
    setupCollectionView()

    navigationItem.title = "Top News"

    if let collectionView = collectionView, let viewModel = viewModel {
      let indexToFetch = Driver.merge(
        collectionView.rx.prefetchItems.asDriver(onErrorJustReturn: []),
        collectionView.rx.willDisplayCell.map { [$1] }.asDriver(onErrorJustReturn: [])
      )
      Driver.combineLatest(
        indexToFetch.distinctUntilChanged(),
        scrollIdleSubject.asDriver(onErrorJustReturn: true)
      )
      .withLatestFrom(viewModel.items) { ($0.0, $0.1, $1) }
      .drive(onNext: { [unowned self] indexPaths, idle, items in
        guard items.isEmpty == false, idle else {
          return
        }
        indexPaths
          .map { items[$0.row].id }
          .forEach {
            self.viewModel?.loadItem.onNext($0)
          }
      }).disposed(by: disposeBag)

      collectionView.rx.modelSelected(TopNewsItem.self)
        .subscribe(onNext: { [unowned self] item in
          if let urlAsString = item.url, let url = URL(string: urlAsString) {
            self.router?.navigate(to: .item(url: url, title: item.title), from: self.navigationController)
          }
        })
        .disposed(by: disposeBag)

      Observable.merge(collectionView.rx.willBeginDragging.asObservable())
        .map { false }
        .bind(to: scrollIdleSubject)
        .disposed(by: disposeBag)

      Observable.merge(collectionView.rx.didEndScrollingAnimation.asObservable(),
                       collectionView.rx.didEndDecelerating.asObservable())
        .map { true }
        .bind(to: scrollIdleSubject)
        .disposed(by: disposeBag)
    }

    viewModel?.refresh.onNext(())
  }

  private func setupCollectionView() {
    collectionView?.register(cellType: TopNewsCellView.self)
    collectionView?.register(cellType: SplashSkeletonCellView.self)

    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      Layout.apply(to: layout)
    }
    collectionView?.dataSource = nil

    let dataSource = RxCollectionViewSectionedReloadDataSource<TopNewsItemModel>(
      configureCell: { [unowned self] _, collectionView, indexPath, item in
        self.viewModel?.loadItem.onNext(item.id)

        if item.loading {
          let cell: SplashSkeletonCellView = collectionView.dequeueReusableCell(for: indexPath)
          cell.startAnimation()
          return cell
        } else {
          let cell: TopNewsCellView = collectionView.dequeueReusableCell(for: indexPath)

          cell.configure(item: item, imageLoader: self.imageLoader, formatter: self.formatter)

          return cell
        }
      }
    )
    if let collectionView = collectionView, let viewModel = viewModel {
      viewModel.items
        .throttle(0.3, latest: true)
        .do(onNext: { [unowned self] items in
          if items.isEmpty {
            self.activityIndicator.startAnimating()
          } else {
            self.activityIndicator.stopAnimating()
          }
        })
        .map { [TopNewsItemModel(model: "", items: $0)] }
        .drive(collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
  }

  private func setupAppBar() {
    view.addSubview(appBar.view)
    appBar.headerView.trackingScrollView = collectionView
    addChild(appBar)
    appBar.didMove(toParent: self)
    appBar.navigationBar.title = "Top Bar"

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
    imageLoader: ImageLoader,
    formatter: Formatter,
    router: Router
  ) -> TopNewsViewController {
    let vc = TopNewsViewController(collectionViewLayout: UICollectionViewFlowLayout())
    vc.viewModel = viewModel
    vc.imageLoader = imageLoader
    vc.formatter = formatter
    vc.router = router
    return vc
  }
}
