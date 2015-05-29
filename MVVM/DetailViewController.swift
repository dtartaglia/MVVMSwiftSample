//
//  DetailViewController.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/25/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class DetailViewController: UIViewController {
	
	@IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
	@IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var amountField: UITextField!
	@IBOutlet weak var resultLabel: UILabel!
	
	var viewModel: DetailViewModel!
	let disposeBag = DisposeBag()
	
	deinit {
		disposeBag.dispose()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.title
		nameField.text = viewModel.nameText
		amountField.text = viewModel.amountText

		let name = nameField.rx_textChanged()
			>- startWith(viewModel.nameText)
			>- map { text in
				return DetailViewModel.convertStringToName(text)
		}

		let amount = amountField.rx_textChanged()
			>- startWith(viewModel.amountText)
			>- map { (text: String) -> Double in
				return DetailViewModel.convertStringToAmount(text)
		}

		combineLatest(name, amount) { name, amount in
			return DetailViewModel.configureResultTextFromName(name, amount: amount)
			}
			>- resultLabel.rx_subscribeTextTo
			>- disposeBag.addDisposable

		combineLatest(name, amount) { ($0, $1) }
			>- sampleLatest(doneBarButtonItem.rx_tap())
			>- subscribeNext { [weak self] name, amount in
				MainScheduler.ensureExecutingOnScheduler()
				if !DetailViewModel.nameValid(name.firstName, name.lastName) {
					self!.warnUser(DetailViewModel.invalidNameMessage, aboutTextField: self!.nameField)
				}
				else if !DetailViewModel.amountValid(amount) {
					self!.warnUser(DetailViewModel.invalidAmountMessage, aboutTextField: self!.amountField)
				}
				else {
					self!.viewModel.payback = Payback(firstName: name.firstName, lastName: name.lastName, createdAt: self!.viewModel.payback.createdAt, updatedAt: NSDate(), amount: amount)
					self!.performSegueWithIdentifier("Unwind", sender: self!)
				}
			}
			>- disposeBag.addDisposable

		cancelBarButtonItem.rx_tap()
			>- subscribeNext { [weak self] _ in
				MainScheduler.ensureExecutingOnScheduler()
				self!.viewModel.canceled = true
				self!.performSegueWithIdentifier("Unwind", sender: self!)
			}
			>- disposeBag.addDisposable
	}

	func warnUser(message: String, aboutTextField textField: UITextField) {
		let okAction = UIAlertAction(title: "OK", style: .Default, handler: { [weak self] _ in
			self!.dismissViewControllerAnimated(true, completion: nil)
		})
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
		alert.addAction(okAction)
		presentViewController(alert, animated: true, completion: nil)
		textField.becomeFirstResponder()
	}
	
}
