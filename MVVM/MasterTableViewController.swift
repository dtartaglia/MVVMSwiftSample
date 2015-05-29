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

	deinit {
		disposeBag.dispose()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableViewDataSource = RxTableViewDataSource(numberOfRowsInSection: { [weak self] (section) -> Int in
			return self!.viewModel.rowCount
			}, cellForRowAtIndexPath: { [weak self] (indexPath) -> UITableViewCell in
				let result = self!.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
				let tableViewModel = self!.viewModel.tableViewModelForIndex(indexPath.row)
				result.textLabel!.text = tableViewModel.textLabelText
				result.detailTextLabel!.text = tableViewModel.detailTextLabelText
				return result
			})

		tableViewDataSource.rx_commitEditingStyleForRowAtIndexPath
			>- subscribeNext { [weak self] (editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath) in
				if editingStyle == .Delete {
					self!.viewModel.removePaybackAtIndex(indexPath.row)
					self!.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
				}
			}
			>- disposeBag.addDisposable

		tableViewDelegate = RxTableViewDelegate()
		tableViewDelegate.rx_didSelectRowAtIndexPath
			>- subscribeNext { [weak self] indexPath in
				self!.viewModel.selectedRow = indexPath.row
				self!.performSegueWithIdentifier("SelectSegue", sender: self)
			}
			>- disposeBag.addDisposable

		tableView.dataSource = tableViewDataSource
		tableView.delegate = tableViewDelegate
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let detailViewModel: DetailViewModel
		if let selectedRow = viewModel.selectedRow {
			detailViewModel = DetailViewModel(payback: viewModel.paybackCollection.paybacks[selectedRow], atIndex: selectedRow)
			viewModel.selectedRow = nil
		}
		else {
			detailViewModel = DetailViewModel()
		}
		let detailViewController = segue.destinationViewController as! DetailViewController
		detailViewController.viewModel = detailViewModel
	}

	// MARK: IBActions
	@IBAction func unwindToMaster(sender: UIStoryboardSegue)
	{
		let sourceViewController = sender.sourceViewController as! DetailViewController
		viewModel.checkInsert(sourceViewController.viewModel)
		tableView.reloadData()
	}
}
