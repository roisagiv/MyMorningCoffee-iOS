//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import UIKit

class NewsItemMoreMenuViewController: UITableViewController {
  public typealias ActionSelected = (ActionItem) -> Void

  public enum ActionItem {
    case openWith

    var title: String {
      switch self {
      case .openWith:
        return "Open with"
      }
    }

    var icon: UIImage {
      switch self {
      case .openWith:
        return Icons.openWith()
      }
    }
  }

  private let actionSelected: ActionSelected?

  init(actionSelected: @escaping ActionSelected) {
    self.actionSelected = actionSelected
    super.init(style: .plain)
  }

  required init?(coder aDecoder: NSCoder) {
    actionSelected = nil
    super.init(coder: aDecoder)
  }

  private static let cellIdentifier = "Cell"

  private let actions: [ActionItem] = [
    ActionItem.openWith
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: type(of: self).cellIdentifier)
  }

  override func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return actions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCell(
      withIdentifier: type(of: self).cellIdentifier, for: indexPath
    )

    if let textLabel = cell.textLabel {
      Theme.apply(.body1, to: textLabel)
    }

    let action = actions[indexPath.row]
    cell.textLabel?.text = action.title
    cell.imageView?.image = action.icon

    return cell
  }

  override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    dismiss(animated: true, completion: nil)
    let action = actions[indexPath.row]
    actionSelected?(action)
  }
}
