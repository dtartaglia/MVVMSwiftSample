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

	var rx_didEndDisplayingCellForRowAtIndexPath: Observable<(cell: UITableViewCell, indexPath: NSIndexPath)> {
		return _didEndDisplayingCellForRowAtIndexPath
	}
	
	var rx_didEndDisplayingHeaderViewForSection: Observable<(view: UIView, section: Int)> {
		return _didEndDisplayingHeaderViewForSection
	}
	
	var rx__didEndDisplayingFooterViewForSection: Observable<(view: UIView, section: Int)> {
		return _didEndDisplayingFooterViewForSection
	}
	
	// Selection
	var rx_didSelectRowAtIndexPath: Observable<NSIndexPath> {
		return _didSelectRowAtIndexPath
	}
	
	var rx_didDeselectRowAtIndexPath: Observable<NSIndexPath> {
		return _didDeselectRowAtIndexPath
	}

	// MARK: Boilerplate
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		sendNext(_willDisplayCellForRowAtIndexPath, (cell: cell, indexPath: indexPath))
	}

	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		sendNext(_willDisplayHeaderViewForSection, (view: view, section: section))
	}
	
	func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		sendNext(_willDisplayFooterViewForSection, (view: view, section: section))
	}
	
	func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		sendNext(_didEndDisplayingHeaderViewForSection, (view: view, section: section))
	}
	
	func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		sendNext(_didEndDisplayingFooterViewForSection, (view: view, section: section))
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		sendNext(_didSelectRowAtIndexPath, indexPath)
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		sendNext(_didDeselectRowAtIndexPath, indexPath)
	}

	private let _willDisplayCellForRowAtIndexPath: Subject<(cell: UITableViewCell, indexPath: NSIndexPath)> = Subject()
	private let _willDisplayHeaderViewForSection: Subject<(view: UIView, section: Int)> = Subject()
	private let _willDisplayFooterViewForSection: Subject<(view: UIView, section: Int)> = Subject()
	private let _didEndDisplayingCellForRowAtIndexPath: Subject<(cell: UITableViewCell, indexPath: NSIndexPath)> = Subject()
	private let _didEndDisplayingHeaderViewForSection: Subject<(view: UIView, section: Int)> = Subject()
	private let _didEndDisplayingFooterViewForSection: Subject<(view: UIView, section: Int)> = Subject()
	private let _didSelectRowAtIndexPath: Subject<NSIndexPath> = Subject()
	private let _didDeselectRowAtIndexPath: Subject<NSIndexPath> = Subject()
	
}
