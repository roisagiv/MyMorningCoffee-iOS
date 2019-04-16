//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import FirebaseAnalytics
import FirebaseCore
import FirebasePerformance
import GRDB
import MaterialComponents
import RHPlaceholder

class SplashViewController: UICollectionViewController {
  private let appBar = MDCAppBarViewController()
  private var router: Router?
  private var remoteConfig: RemoteConfigType?
  private var databaseWriter: DatabaseWriter?
  private let placeHolderMarker = Placeholder()

  override func viewDidLoad() {
    super.viewDidLoad()

    Theme.apply(to: self)
    Theme.apply(to: collectionView)

    setupCollectionView()
    setupAppBar()

    if let remoteConfig = remoteConfig {
      remoteConfig.fetch(completionHandler: { [unowned self, remoteConfig] status, error in
        if status == .success {
          _ = self.remoteConfig?.activateFetched()
        } else {
          Logger.default.error("error with config - \(error?.localizedDescription ?? "")")
        }
        do {
          if let databaseWriter = self.databaseWriter {
            try DatabaseMigrations.migrate(database: databaseWriter)
            try DatabaseMigrations.trim(database: databaseWriter)
          }
        } catch {
          Logger.default.error("error with migration - \(error.localizedDescription)")
        }

        let appDelegate = UIApplication.shared.delegate as? AppDelegateType
        appDelegate?.remoteConfigDidFetch(remoteConfig: remoteConfig)
        self.router?.root(route: .topNews)
      })
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  private func setupAppBar() {
    Theme.apply(to: appBar)
    appBar.headerView.trackingScrollView = collectionView
    view.addSubview(appBar.view)
    addChild(appBar)
    appBar.didMove(toParent: self)
    appBar.navigationBar.title = ""
  }

  private func setupCollectionView() {
    collectionView?.register(cellType: SplashSkeletonCellView.self)
    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.minimumLineSpacing = 32
      let width = collectionView.bounds.width
      let size = CGSize(width: width - 32, height: SplashSkeletonCellView.height)
      layout.itemSize = size
    }
  }
}

extension SplashViewController {
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: SplashSkeletonCellView = collectionView.dequeueReusableCell(for: indexPath)
    placeHolderMarker.register(cell.placeHolders())
    placeHolderMarker.startAnimation()
    return cell
  }

  override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return 2
  }
}

extension SplashViewController {
  class func create(router: Router,
                    remoteConfig: RemoteConfigType,
                    databaseWriter: DatabaseWriter) -> SplashViewController {
    let vc = SplashViewController(collectionViewLayout: UICollectionViewFlowLayout())
    vc.router = router
    vc.remoteConfig = remoteConfig
    vc.databaseWriter = databaseWriter
    return vc
  }
}
