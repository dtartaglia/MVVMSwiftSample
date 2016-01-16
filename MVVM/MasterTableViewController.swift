//
//  MasterViewController.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/25/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit
import RxSwift


class MasterTableViewController: UITableViewController {

	@IBOutlet weak var addBarButtonItem: UIBarButtonItem!

	var viewModel = MasterTableViewModel()
	var tableViewDataSource: RxTableViewDataSource!
	var tableViewDelegate: RxTableViewDelegate!

	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableViewDataSource = RxTableViewDataSource(numberOfRowsInSection: { [weak self] _ in
			return self!.viewModel.rowCount
			}, cellForRowAtIndexPath: { [weak self] indexPath in
				let result = self!.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
				let tableViewModel = self!.viewModel.tableViewModelForIndex(indexPath.row)
				result.textLabel!.text = tableViewModel.textLabelText
				result.detailTextLabel!.text = tableViewModel.detailTextLabelText
				return result
			})
		tableViewDataSource.rx_commitEditingStyleForRowAtIndexPath.subscribeNext({ [weak self] editingStyle, indexPath in
				if editingStyle == .Delete {
					self!.viewModel.removePaybackAtIndex(indexPath.row)
					self!.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
				}
			}).addDisposableTo(disposeBag)

		tableViewDelegate = RxTableViewDelegate()
		tableViewDelegate.rx_didSelectRowAtIndexPath.subscribeNext({ [weak self] indexPath in
				self!.segueToDetailWithSelected(indexPath.row)
			}).addDisposableTo(disposeBag)

		tableView.dataSource = tableViewDataSource
		tableView.delegate = tableViewDelegate

		addBarButtonItem.rx_tap.subscribeNext({ [weak self] in
				self!.segueToDetailWithSelected(nil)
		}).addDisposableTo(disposeBag)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.selectedRow = nil
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let detailViewController = segue.destinationViewController as! DetailViewController
		detailViewController.viewModel = viewModel.detailViewModel
	}

	// MARK: IBActions
	@IBAction func unwindToMaster(sender: UIStoryboardSegue) {
		let detailViewController = sender.sourceViewController as! DetailViewController
		viewModel.checkInsert(detailViewController.viewModel)
		tableView.reloadData()
	}

	func segueToDetailWithSelected(selected: Int?) {
		viewModel.selectedRow = selected
		performSegueWithIdentifier("DetailSegue", sender: self)
	}

}
