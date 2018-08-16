//
//  TopNewsViewController.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Fakery
import MaterialComponents
import UIKit

class TopNewsViewController: MDCCollectionViewController {
  fileprivate let appBar = MDCAppBarViewController()
  private let theme: Theme = Theme()
  fileprivate let faker = Faker(locale: "en-US")

  override func viewDidLoad() {
    super.viewDidLoad()
    theme.apply(to: collectionView)
    setupAppBar()
    styler.cellLayoutType = .list
    styler.cellStyle = .card

    collectionView?.register(MDCCollectionViewTextCell.self, forCellWithReuseIdentifier: "cell")
    navigationItem.title = "Top News"
  }

  private func setupAppBar() {
    view.addSubview(appBar.view)
    appBar.headerView.trackingScrollView = collectionView
    appBar.didMove(toParentViewController: self)
    appBar.navigationBar.title = "Top Bar"
    theme.apply(to: appBar)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
}

extension TopNewsViewController {
  override func collectionView(_: UICollectionView, cellHeightAt _: IndexPath) -> CGFloat {
    return MDCCellDefaultThreeLineHeight
  }

  override func numberOfSections(in _: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_: UICollectionView,
                               numberOfItemsInSection _: Int) -> Int {
    return 20
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell: MDCCollectionViewTextCell =
      collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MDCCollectionViewTextCell
    else {
      return MDCCollectionViewTextCell(frame: CGRect.zero)
    }

    theme.apply(to: cell)

    cell.textLabel?.text = faker.lorem.sentences(amount: 2)
    cell.detailTextLabel?.text = faker.lorem.sentences(amount: 2)
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
