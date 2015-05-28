//
//  MasterViewController.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/25/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit


class MasterTableViewController: UITableViewController {
	
	@IBOutlet weak var addBarButtonItem: UIBarButtonItem!
	
	var viewModel = MasterTableViewModel()

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

	// MARK: UITableViewDataSource
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.rowCount
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let result = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		let tableViewModel = viewModel.tableViewModelForIndex(indexPath.row)
		result.textLabel!.text = tableViewModel.textLabelText
		result.detailTextLabel!.text = tableViewModel.detailTextLabelText
		return result
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			viewModel.removePaybackAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}

	// MARK: UITableViewDelegate
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		viewModel.selectedRow = indexPath.row
		performSegueWithIdentifier("SelectSegue", sender: self)
	}

	// MARK: IBActions
	@IBAction func unwindToMaster(sender: UIStoryboardSegue)
	{
		let sourceViewController = sender.sourceViewController as! DetailViewController
		viewModel.checkInsert(sourceViewController.viewModel)
		let tableView = view as! UITableView
		tableView.reloadData()
	}
}
