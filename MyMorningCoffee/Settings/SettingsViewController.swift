//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import Reusable
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class SettingsViewController: MDCCollectionViewController {
  private var viewModel: SettingsViewModelType?
  private var router: Router?
  private var dataSource: RxCollectionViewSectionedReloadDataSource<SettingsViewModelSection>?
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Settings"

    collectionView.register(cellType: SettingsCell.self)
    collectionView.register(supplementaryViewType: SettingsHeaderCell.self,
                            ofKind: UICollectionView.elementKindSectionHeader)

    guard let viewModel = viewModel else { return }

    collectionView.dataSource = nil

    let dataSource = RxCollectionViewSectionedReloadDataSource<SettingsViewModelSection>(
      configureCell: { _, collectionView, indexPath, item in
        let cell: SettingsCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(item: item)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.description

        return cell
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let cell: SettingsHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        cell.configure()

        let section = dataSource.sectionModels[indexPath.section]
        cell.detailTextLabel?.text = section.section.title

        return cell
      }
    )

    collectionView.rx
      .modelSelected(SettingsViewModelSection.SettingsItem.self)
      .bind(to: viewModel.itemClicked.inputs)
      .disposed(by: disposeBag)

    viewModel.items
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    viewModel.route.drive(onNext: { [unowned self] route in
      self.router?.navigate(to: route, from: self.navigationController)
    }).disposed(by: disposeBag)

    self.dataSource = dataSource

    Theme.apply(to: self)
    Theme.apply(to: collectionView)
    styler.cellStyle = .default
    styler.shouldHideSeparators = false
  }

  override func collectionView(_ collectionView: UICollectionView,
                               layout _: UICollectionViewLayout,
                               referenceSizeForHeaderInSection _: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: SettingsHeaderCell.height)
  }

  override func collectionView(_: UICollectionView, cellHeightAt indexPath: IndexPath) -> CGFloat {
    guard let item = try? self.dataSource?.model(at: indexPath) as? SettingsViewModelSection.SettingsItem else {
      return 0
    }

    return item?.description != nil ? MDCCellDefaultTwoLineHeight : MDCCellDefaultOneLineHeight
  }

  override func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    guard let item = try? self.dataSource?.model(at: indexPath) as? SettingsViewModelSection.SettingsItem else {
      return false
    }

    return item?.clickable ?? false
  }

  class SettingsHeaderCell: MDCCollectionViewTextCell, Reusable {
    static let height: CGFloat = MDCCellDefaultOneLineHeight

    func configure() {
      Theme.apply(to: self)
      shouldHideSeparator = false
      backgroundColor = .clear
    }
  }

  class SettingsCell: MDCCollectionViewTextCell, Reusable {
    func configure(item: SettingsViewModelSection.SettingsItem) {
      Theme.apply(to: self)
      shouldHideSeparator = false

      if item.navigational {
        accessoryType = .disclosureIndicator
      } else {
        accessoryType = .none
      }

      guard let enabled = item.enabled else { return }

      let toggle = UISwitch(frame: CGRect.zero)
      toggle.addTarget(self, action: #selector(switchToggled(sender:)), for: .touchUpInside)
      toggle.isOn = enabled

      Theme.apply(to: toggle)
      accessoryView = toggle
    }

    @objc private func switchToggled(sender: UISwitch) {
      print("switch = \(sender)")
    }
  }
}

extension SettingsViewController {
  class func create(viewModel: SettingsViewModelType, router: Router) -> SettingsViewController {
    let vc = SettingsViewController()
    vc.viewModel = viewModel
    vc.router = router
    return vc
  }
}
