//
//  RxTableViewDataSource.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/29/15.
//  Copyright (c) 2015 Daniel Tartaglia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class RxTableViewDataSource: NSObject, UITableViewDataSource {

	let numberOfRowsInSection: (section: Int) -> Int
	let cellForRowAtIndexPath: (indexPath: NSIndexPath) -> UITableViewCell

	var numberOfSections: (() -> Int)?
	var titleForHeaderInSection: ((section: Int) -> String?)?
	var titleForFooterInSection: ((section: Int) -> String?)?

	// Editing
	var canEditRowAtIndexPath: ((indexPath: NSIndexPath) -> Bool)?

	// Moving/reordering
	var canMoveRowAtIndexPath: ((indexPath: NSIndexPath) -> Bool)?

	// Index
	var sectionIndexTitles: (() -> [AnyObject])?
	var sectionForSectionIndexTitleAtIndex: ((title: String, index: Int) -> Int)?

	// Data manipulation - insert and delete support
	var rx_commitEditingStyleForRowAtIndexPath: Observable<(editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath)> {
		return _commitEditingStyleForRowAtIndexPath
	}

	var rx_moveRowAtIndexPathToIndexPath: Observable<(sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath)> {
		return _moveRowAtIndexPathToIndexPath
	}

	init(numberOfRowsInSection: (section: Int) -> Int, cellForRowAtIndexPath: (indexPath: NSIndexPath) -> UITableViewCell) {
		self.numberOfRowsInSection = numberOfRowsInSection
		self.cellForRowAtIndexPath = cellForRowAtIndexPath
	}

	// MARK: Boilerplate
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfRowsInSection(section: section)
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return cellForRowAtIndexPath(indexPath: indexPath)
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let callback = numberOfSections {
			return callback()
		}
		else {
			return 1
		}
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let callback = titleForHeaderInSection {
			return callback(section: section)
		}
		else {
			return nil
		}
	}

	func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if let callback = titleForFooterInSection {
			return callback(section: section)
		}
		else {
			return nil
		}
	}

	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if let callback = canEditRowAtIndexPath {
			return callback(indexPath: indexPath)
		}
		else {
			return true
		}
	}

	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if let callback = canMoveRowAtIndexPath {
			return callback(indexPath: indexPath)
		}
		else {
			return true
		}
	}

	func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
		if let callback = sectionIndexTitles {
			return callback()
		}
		else {
			return []
		}
	}

	func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
		if let callback = sectionForSectionIndexTitleAtIndex {
			return callback(title: title, index: index)
		}
		else {
			return 0 
		}
	}

	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		sendNext(_commitEditingStyleForRowAtIndexPath, (editingStyle: editingStyle, indexPath: indexPath))
	}

	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		sendNext(_moveRowAtIndexPathToIndexPath, (sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath))
	}

	private let _commitEditingStyleForRowAtIndexPath: Subject<(editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath)> = Subject()
	private let _moveRowAtIndexPathToIndexPath: Subject<(sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath)> = Subject()

}
