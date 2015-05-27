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
	let disposeBag = DisposeBag()

	deinit {
		disposeBag.dispose()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		disposeBag.dispose()
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

	@IBAction func unwindToMaster(sender: UIStoryboardSegue)
	{
		let sourceViewController = sender.sourceViewController as! DetailViewController
		viewModel.checkInsert(sourceViewController.viewModel)
	}
}


struct MasterTableViewModel {
	
	var paybackCollection = PaybackCollection()
	var selectedRow: Int?

	mutating func checkInsert(detailViewModel: DetailViewModel) {
		let payback = detailViewModel.payback
		if payback.isValid && !detailViewModel.canceled {
			if let selectedRow = detailViewModel.index {
				paybackCollection.replacePayback(payback, atIndex: selectedRow)
			}
			else {
				paybackCollection.insertPayback(payback)
			}
		}
	}
}
