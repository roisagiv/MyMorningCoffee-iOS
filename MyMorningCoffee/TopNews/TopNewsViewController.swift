//
//  TopNewsViewController.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import RxDataSources
import RxSwift
import SafariServices
import UIKit

class TopNewsViewController: MDCCollectionViewController {
  typealias TopNewsItemModel = SectionModel<String, TopNewsItem>

  fileprivate let appBar = MDCAppBarViewController()
  private let activityIndicator = MDCActivityIndicator()

  fileprivate var items: [TopNewsItem] = []
  private let disposeBag = DisposeBag()
  fileprivate var viewModel: TopNewsViewModelType?
  fileprivate var imageLoader: ImageLoader?
  fileprivate var router: Router?
  fileprivate var formatter: Formatter?

  override func viewDidLoad() {
    super.viewDidLoad()

    Theme.apply(to: collectionView)
    setupAppBar()
    setupCollectionView()

    navigationItem.title = "Top News"

    let disposable = viewModel?.items.drive(onNext: { [weak self] items in
      self?.items = items
      self?.collectionView?.reloadData()
      self?.activityIndicator.stopAnimating()
    })
    if let disposable = disposable {
      disposeBag.insert(disposable)
    }

    viewModel?.refresh.onNext(())
    viewModel?.loading.drive(onNext: { [weak self] loading in
      if loading {
        self?.activityIndicator.startAnimating()
      } else {
        self?.activityIndicator.stopAnimating()
      }
    }).disposed(by: disposeBag)

    let dataSource = RxCollectionViewSectionedReloadDataSource<TopNewsItemModel>(
      configureCell: { [unowned self] _, collectionView, indexPath, item in
        self.viewModel?.loadItem.onNext(item.id)

        let cell: TopNewsCellView = collectionView.dequeueReusableCell(for: indexPath)

        cell.configure(item: item, imageLoader: self.imageLoader, formatter: self.formatter)

        return cell
      }
    )
    if let collectionView = collectionView, let viewModel = viewModel {
      collectionView.dataSource = nil
      viewModel.items
        .map { [TopNewsItemModel(model: "", items: $0)] }
        .drive(collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)

      collectionView.rx.prefetchItems.distinctUntilChanged().subscribe(onNext: { [unowned self] indexPaths in
        indexPaths
          .map { self.items[$0.row].id }
          .forEach {
            self.viewModel?.loadItem.onNext($0)
          }
      }).disposed(by: disposeBag)

      collectionView.rx.itemSelected
        .subscribe(onNext: { [unowned self] indexPath in
          let item = self.items[indexPath.row]
          if let urlAsString = item.url, let url = URL(string: urlAsString) {
            self.router?.navigate(to: .item(url: url, title: item.title), from: self.navigationController)
          }
        })
        .disposed(by: disposeBag)
    }
  }

  private func setupCollectionView() {
    styler.cellLayoutType = .list
    styler.cardBorderRadius = 4
    styler.cellStyle = .card

    collectionView?.register(cellType: TopNewsCellView.self)
    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.minimumLineSpacing = 80
    }
  }

  private func setupAppBar() {
    view.addSubview(appBar.view)
    appBar.headerView.trackingScrollView = collectionView
    appBar.didMove(toParentViewController: self)
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

    Theme.apply(to: appBar)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
}

extension TopNewsViewController {
  override func collectionView(_: UICollectionView, cellHeightAt _: IndexPath) -> CGFloat {
    return TopNewsCellView.height
  }
}

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

  override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar
  }

  override var childViewControllerForStatusBarHidden: UIViewController? {
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
    let vc = TopNewsViewController()
    vc.viewModel = viewModel
    vc.imageLoader = imageLoader
    vc.formatter = formatter
    vc.router = router
    return vc
  }
}
