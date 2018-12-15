//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Freedom
import MaterialComponents
import RxSwift
import RxWebKit
import UIKit
import WebKit

class NewsItemViewController: UIViewController {
  fileprivate let appBar = MDCAppBarViewController()
  fileprivate var webView: WKWebView?
  fileprivate var url: URL?
  fileprivate var itemTitle: String?
  private let disposeBag = DisposeBag()
  private let progressView = MDCProgressView(frame: CGRect.zero)
  private var analyticsService: AnalyticsService?

  /* testable*/ var finishLoading: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
    setupAppBar()

    appBar.headerView.trackingScrollView = webView?.scrollView

    webView?.rx.loading.subscribe(onNext: { [weak self] loading in
      self?.finishLoading = !loading
      if !loading {
        self?.progressView.progress = 0
      }
    }).disposed(by: disposeBag)

    if let url = self.url {
      webView?.load(URLRequest(url: url))
    }
    webView?.rx.estimatedProgress.subscribe(onNext: { [weak self] estimatedProgress in
      let progress = Float(estimatedProgress)
      self?.progressView.setProgress(progress, animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }

  private func setupAppBar() {
    if parent != nil {
      appBar.inferTopSafeAreaInsetFromViewController = true
    }
    appBar.useAdditionalSafeAreaInsetsForWebKitScrollViews = true
    appBar.headerView.minMaxHeightIncludesSafeArea = false
    appBar.isTopLayoutGuideAdjustmentEnabled = true
    appBar.topLayoutGuideViewController = self
    appBar.headerView.shiftBehavior = .enabled
    appBar.headerView.delegate = self

    addChild(appBar)

    progressView.progress = 1
    progressView.backwardProgressAnimationMode = .animate
    let progressViewHeight = CGFloat(1)
    progressView.frame = CGRect(
      x: 0,
      y: view.bounds.height / 2 - progressViewHeight,
      width: view.bounds.width,
      height: progressViewHeight
    )
    appBar.headerStackView.bottomBar = progressView
    Theme.apply(to: progressView)
    Theme.apply(to: appBar)
    setNeedsStatusBarAppearanceUpdate()

    var frame: CGRect = appBar.view.frame
    frame.origin.x = 0
    frame.size.width = appBar.parent?.view.bounds.size.width ?? 0
    appBar.view.frame = frame
    view.addSubview(appBar.view)
    appBar.didMove(toParent: self)

    let moreOptionsButton = UIBarButtonItem(
      image: Icons.moreOptions(),
      style: .done,
      target: self,
      action: #selector(onMoreOptionsClicked)
    )
    appBar.navigationBar.rightBarButtonItem = moreOptionsButton
  }

  private func setupWebView() {
    let config = WKWebViewConfiguration()
    let webView = WKWebView(frame: view.bounds, configuration: config)
    webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    webView.scrollView.delegate = appBar
    view.addSubview(webView)

    self.webView = webView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
    analyticsService?.track(event: .newItemScreenView(url: url?.absoluteString ?? ""))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    appBar.updateTopLayoutGuide()
  }

  @objc private func onMoreOptionsClicked() {
    let menu = NewsItemMoreMenuViewController { [weak self] action in
      switch action {
      case .openWith:
        guard let url = self?.url, let `self` = self else {
          return
        }

        let activities = Freedom.browsers()
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: activities)
        self.present(vc, animated: true, completion: nil)
        return
      }
    }
    let bottomSheet = MDCBottomSheetController(contentViewController: menu)
    bottomSheet.trackingScrollView = menu.tableView
    bottomSheet.dismissOnBackgroundTap = true
    present(bottomSheet, animated: true, completion: nil)
  }
}

extension NewsItemViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerView.trackingScrollView {
      appBar.headerView.trackingScrollDidScroll()
    }
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerView.trackingScrollView {
      appBar.headerView.trackingScrollDidEndDecelerating()
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView == appBar.headerView.trackingScrollView {
      let headerView = appBar.headerView
      headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
    }
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
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
}

extension NewsItemViewController: MDCFlexibleHeaderViewDelegate {
  func flexibleHeaderViewNeedsStatusBarAppearanceUpdate(_: MDCFlexibleHeaderView) {
    setNeedsStatusBarAppearanceUpdate()
  }

  func flexibleHeaderViewFrameDidChange(_ headerView: MDCFlexibleHeaderView) {
    if let backButton = appBar.navigationBar.backItem,
      let backButtonImage = MDCIcons.imageFor_ic_arrow_back() {
      let minValue: CGFloat = 76
      let maxValue: CGFloat = 100
      let value = max(headerView.scrollPhaseValue, minValue)
      let alpha: CGFloat = (value - minValue) / (maxValue - minValue)

      backButton.image = Images.imageWithAlpha(backButtonImage, alpha: alpha)
      appBar.navigationBar.rightBarButtonItem?.image = Images.imageWithAlpha(
        Icons.moreOptions(), alpha: alpha
      )
    }
  }
}

extension NewsItemViewController {
  class func create(url: URL, title: String, analyticsService: AnalyticsService) -> NewsItemViewController {
    let vc = NewsItemViewController(nibName: nil, bundle: Bundle.main)
    vc.url = url
    vc.itemTitle = title
    vc.analyticsService = analyticsService
    return vc
  }
}
