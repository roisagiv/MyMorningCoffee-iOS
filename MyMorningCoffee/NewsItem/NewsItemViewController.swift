//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

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
    view.addSubview(appBar.view)
    appBar.useAdditionalSafeAreaInsetsForWebKitScrollViews = true
    appBar.topLayoutGuideViewController = self
    appBar.didMove(toParentViewController: self)
    appBar.navigationBar.title = itemTitle
    let backButton = UIBarButtonItem(title: "",
                                     style: .done,
                                     target: self,
                                     action: #selector(back))
    backButton.image = MDCIcons.imageFor_ic_arrow_back()
    appBar.navigationBar.backItem = backButton

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
  }

  private func setupWebView() {
    let config = WKWebViewConfiguration()
    let webView = WKWebView(frame: view.bounds, configuration: config)
    webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    webView.scrollView.delegate = self
    view.addSubview(webView)

    self.webView = webView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  @objc private func back() {
    navigationController?.popViewController(animated: true)
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

  override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar
  }
}

extension NewsItemViewController {
  class func create(url: URL, title: String) -> NewsItemViewController {
    let vc = NewsItemViewController(nibName: nil, bundle: Bundle.main)
    vc.url = url
    vc.itemTitle = title
    return vc
  }
}
