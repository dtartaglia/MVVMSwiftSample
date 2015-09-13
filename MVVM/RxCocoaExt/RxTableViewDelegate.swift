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
		_willDisplayCellForRowAtIndexPath.on(.Next((cell: cell, indexPath: indexPath)))
	}

	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		_willDisplayHeaderViewForSection.on(.Next((view: view, section: section)))
	}
	
	func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		_willDisplayFooterViewForSection.on(.Next((view: view, section: section)))
	}
	
	func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		_didEndDisplayingHeaderViewForSection.on(.Next((view: view, section: section)))
	}
	
	func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		_didEndDisplayingFooterViewForSection.on(.Next((view: view, section: section)))
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		_didSelectRowAtIndexPath.on(.Next(indexPath))
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		_didDeselectRowAtIndexPath.on(.Next(indexPath))
	}

	private let _willDisplayCellForRowAtIndexPath: PublishSubject<(cell: UITableViewCell, indexPath: NSIndexPath)> = PublishSubject()
	private let _willDisplayHeaderViewForSection: PublishSubject<(view: UIView, section: Int)> = PublishSubject()
	private let _willDisplayFooterViewForSection: PublishSubject<(view: UIView, section: Int)> = PublishSubject()
	private let _didEndDisplayingCellForRowAtIndexPath: PublishSubject<(cell: UITableViewCell, indexPath: NSIndexPath)> = PublishSubject()
	private let _didEndDisplayingHeaderViewForSection: PublishSubject<(view: UIView, section: Int)> = PublishSubject()
	private let _didEndDisplayingFooterViewForSection: PublishSubject<(view: UIView, section: Int)> = PublishSubject()
	private let _didSelectRowAtIndexPath: PublishSubject<NSIndexPath> = PublishSubject()
	private let _didDeselectRowAtIndexPath: PublishSubject<NSIndexPath> = PublishSubject()
	
}
