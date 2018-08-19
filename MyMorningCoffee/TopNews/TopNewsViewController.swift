//
//  TopNewsViewController.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Fakery
import MaterialComponents
import RxSwift
import UIKit

class TopNewsViewController: MDCCollectionViewController {
  fileprivate let appBar = MDCAppBarViewController()
  fileprivate var items: [TopNewsItem] = []
  private let disposeBag = DisposeBag()

  fileprivate let viewModel: TopNewsViewModelType = Injector.topNewsViewModel

  override func viewDidLoad() {
    super.viewDidLoad()
    Theme.apply(to: collectionView)
    setupAppBar()
    setupCollectionView()

    navigationItem.title = "Top News"

    let disposable = viewModel.items.drive(onNext: { [weak self] items in
      self?.items = items
      self?.collectionView?.reloadData()
    })
    disposeBag.insert(disposable)
    viewModel.refresh.onNext(())
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
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = items[indexPath.row]
    viewModel.loadItem.onNext(item.id)

    let cell: TopNewsCellView = collectionView.dequeueReusableCell(for: indexPath)

    cell.configure(item: item)

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
