//
//  TopNewsViewController.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Fakery
import MaterialComponents
import RxDataSources
import RxSwift
import UIKit

class TopNewsViewController: MDCCollectionViewController {
  typealias TopNewsItemModel = SectionModel<String, TopNewsItem>

  fileprivate let appBar = MDCAppBarViewController()
  fileprivate var items: [TopNewsItem] = []
  private let disposeBag = DisposeBag()

  fileprivate var viewModel: TopNewsViewModelType?
  fileprivate var imageLoader: ImageLoader?

  override func viewDidLoad() {
    super.viewDidLoad()

    Theme.apply(to: collectionView)
    setupAppBar()
    setupCollectionView()

    navigationItem.title = "Top News"

    let disposable = viewModel?.items.drive(onNext: { [weak self] items in
      self?.items = items
      self?.collectionView?.reloadData()
    })
    if let disposable = disposable {
      disposeBag.insert(disposable)
    }

    viewModel?.refresh.onNext(())

    let dataSource = RxCollectionViewSectionedReloadDataSource<TopNewsItemModel>(
      configureCell: { [unowned self] _, collectionView, indexPath, item in
        self.viewModel?.loadItem.onNext(item.id)

        let cell: TopNewsCellView = collectionView.dequeueReusableCell(for: indexPath)

        cell.configure(item: item, imageLoader: self.imageLoader)

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

  override func numberOfSections(in _: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_: UICollectionView,
                               numberOfItemsInSection _: Int) -> Int {
    print("numberOfItemsInSection")
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = items[indexPath.row]
    viewModel?.loadItem.onNext(item.id)

    let cell: TopNewsCellView = collectionView.dequeueReusableCell(for: indexPath)

    cell.configure(item: item, imageLoader: imageLoader)

    return cell
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
}

extension TopNewsViewController {
  class func create(viewModel: TopNewsViewModelType, imageLoader: ImageLoader) -> TopNewsViewController {
    let vc = TopNewsViewController()
    vc.viewModel = viewModel
    vc.imageLoader = imageLoader
    return vc
  }
}
