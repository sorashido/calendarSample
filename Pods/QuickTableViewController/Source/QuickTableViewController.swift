//
//  QuickTableViewController.swift
//  QuickTableViewController
//
//  Created by Ben on 25/08/2015.
//  Copyright (c) 2015 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

/// A table view controller that shows `tableContents` as formatted sections and rows.
open class QuickTableViewController: UIViewController,
  UITableViewDataSource,
  UITableViewDelegate {

  /// A Boolean value indicating if the controller clears the selection when the collection view appears.
  public var clearsSelectionOnViewWillAppear = true

  /// Returns the table view managed by the controller object.
  /// To override the cell type to display certain rows, register a different type with `row.cellReuseIdentifier`.
  public private(set) var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)

  /// The layout of sections and rows to display in the table view.
  public var tableContents: [Section] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  // MARK: - Initialization

  /**
   Initializes a table view controller to manage a table view of a given style.

   - parameter style: A constant that specifies the style of table view that the controller object is to manage (UITableViewStylePlain or UITableViewStyleGrouped).

   - returns: An initialized `QuickTableViewController` object.
   */
  public convenience init(style: UITableViewStyle) {
    self.init(nibName: nil, bundle: nil)
    tableView = UITableView(frame: CGRect.zero, style: style)
  }

  deinit {
    tableView.dataSource = nil
    tableView.delegate = nil
  }

  // MARK: - UIViewController

  open override func loadView() {
    super.loadView()
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(SwitchCell.self, forCellReuseIdentifier: NSStringFromClass(SwitchCell.self))
    tableView.register(TapActionCell.self, forCellReuseIdentifier: NSStringFromClass(TapActionCell.self))
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow, clearsSelectionOnViewWillAppear {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  // MARK: - UITableViewDataSource

  open func numberOfSections(in tableView: UITableView) -> Int {
    return tableContents.count
  }

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableContents[section].rows.count
  }

  open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return tableContents[section].title
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = tableContents[indexPath.section].rows[indexPath.row]
    var cell = tableView.dequeueReusableCell(withIdentifier: row.cellReuseIdentifier)

    switch (row, row.subtitle, row.action) {
    case let (_ as NavigationRow, .some(subtitle), action):
      // Match UITableViewCellStyle to each Subtitle.style
      switch subtitle {
      case .none:
        cell = cell ?? UITableViewCell(style: .default, reuseIdentifier: subtitle.style)
      case .belowTitle(_):
        cell = cell ?? UITableViewCell(style: .subtitle, reuseIdentifier: subtitle.style)
      case .rightAligned(_):
        cell = cell ?? UITableViewCell(style: .value1, reuseIdentifier: subtitle.style)
      case .leftAligned(_):
        cell = cell ?? UITableViewCell(style: .value2, reuseIdentifier: subtitle.style)
      }

      cell?.detailTextLabel?.text = subtitle.text
      cell?.accessoryType = (action == nil) ? .none : .disclosureIndicator

    case let (row as SwitchRow, _, _):
      cell = cell ?? SwitchCell(style: .default, reuseIdentifier: row.cellReuseIdentifier)
      cell?.textLabel?.text = row.title

      let switchControl = (cell as? SwitchCell)?.switchControl
      switchControl?.isOn = row.switchValue

      if switchControl?.actions(forTarget: self, forControlEvent: .valueChanged) == nil {
        switchControl?.addTarget(self, action: .didToggleSwitch, for: UIControlEvents.valueChanged)
      }

    case let (row as TapActionRow, _, _):
      cell = cell ?? TapActionCell(style: .default, reuseIdentifier: row.cellReuseIdentifier)

    default:
      break
    }

    if let icon = (row as? IconEnabled)?.icon {
      if let image = icon.image {
        cell?.imageView?.image = image
      }
      if let image = icon.highlightedImage {
        cell?.imageView?.highlightedImage = image
      }
    }

    cell?.textLabel?.text = row.title
    return cell ?? tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
  }

  open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return tableContents[section].footer
  }

  // MARK: - UITableViewDelegate

  open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    let row = tableContents[indexPath.section].rows[indexPath.row]
    return (row is TapActionRow || row is NavigationRow) && (row.action != nil)
  }

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = tableContents[indexPath.section].rows[indexPath.row]

    switch (row, row.action) {
    case let (row as NavigationRow, navigation):
      navigation?(row)
    case let (row as TapActionRow, tap):
      tap?(row)
      fallthrough
    default:
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  // MARK: - IBAction

  @objc fileprivate func didToggleSwitch(_ sender: UISwitch) {
    guard
      let cell = sender.containerCell,
      let indexPath = tableView.indexPath(for: cell),
      let switchRow = tableContents[indexPath.section].rows[indexPath.row] as? SwitchRow
    else {
      return
    }

    // Replace the original row in tableContents
    var row = switchRow
    row.switchValue = sender.isOn
    tableContents[indexPath.section].rows[indexPath.row] = row
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension UIView {

  var containerCell: UITableViewCell? {
    return (superview as? UITableViewCell) ?? superview?.containerCell
  }

}


private extension Selector {
  static let didToggleSwitch = #selector(QuickTableViewController.didToggleSwitch(_:))
}
