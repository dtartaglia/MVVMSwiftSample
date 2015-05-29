//
//  RxTableViewDelegate.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/29/15.
//  Copyright (c) 2015 Daniel Tartaglia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class RxTableViewDelegate: NSObject, UITableViewDelegate {

	// Display customization
	var rx_willDisplayCellForRowAtIndexPath: Observable<(cell: UITableViewCell, indexPath: NSIndexPath)> {
		return _willDisplayCellForRowAtIndexPath
	}

	var rx_willDisplayHeaderViewForSection: Observable<(view: UIView, section: Int)> {
		return _willDisplayHeaderViewForSection
	}

	var rx_willDisplayFooterViewForSection: Observable<(view: UIView, section: Int)> {
		return _willDisplayFooterViewForSection
	}

	// Selection
	var rx_didSelectRowAtIndexPath: Observable<NSIndexPath> {
		return _didSelectRowAtIndexPath
	}

	// MARK: Boilerplate
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		sendNext(_willDisplayCellForRowAtIndexPath, (cell: cell, indexPath: indexPath))
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		sendNext(_didSelectRowAtIndexPath, indexPath)
	}

	private let _willDisplayCellForRowAtIndexPath: Subject<(cell: UITableViewCell, indexPath: NSIndexPath)> = Subject()
	private let _willDisplayHeaderViewForSection: Subject<(view: UIView, section: Int)> = Subject()
	private let _willDisplayFooterViewForSection: Subject<(view: UIView, section: Int)> = Subject()
	private let _didSelectRowAtIndexPath: Subject<NSIndexPath> = Subject()
	
}
