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
		nameField.text = viewModel.getNameText()
		amountField.text = viewModel.getAmountText()

		let name = nameField.rx_textChanged()
			>- startWith(viewModel.getNameText())
			>- map { (text: String?) -> (firstName: String, lastName: String) in
				return self.viewModel.convertStringToName(text)
		}

		let amount = amountField.rx_textChanged()
			>- startWith(viewModel.getAmountText())
			>- map { (text: String?) -> Double in
				return self.viewModel.convertStringToAmount(text)
		}

		combineLatest(name, amount) { (name, amount) -> String in
			return self.viewModel.configureResultTextFromName(name, amount: amount)
			}
			>- resultLabel.rx_subscribeTextTo
			>- disposeBag.addDisposable

		combineLatest(name, amount) { ($0, $1) }
			>- sampleLatest(doneBarButtonItem.rx_tap())
			>- subscribeNext { (name: (firstName: String, lastName: String), amount: Double) in
				if !self.viewModel.nameValid(name.firstName, name.lastName) {
					self.warnUser(self.viewModel.invalidNameMessage, aboutTextField: self.nameField)
				}
				else if !self.viewModel.amountValid(amount) {
					self.warnUser(self.viewModel.invalidAmountMessage, aboutTextField: self.amountField)
				}
				else {
					self.viewModel.payback = Payback(firstName: name.firstName, lastName: name.lastName, createdAt: self.viewModel.payback.createdAt, updatedAt: NSDate(), amount: amount)
					self.performSegueWithIdentifier("Unwind", sender: self)
				}
			}
			>- disposeBag.addDisposable

		cancelBarButtonItem.rx_tap()
			>- subscribeNext { _ in
				self.viewModel.canceled = true
				self.performSegueWithIdentifier("Unwind", sender: self)
			}
			>- disposeBag.addDisposable
	}

	func warnUser(message: String, aboutTextField textField: UITextField) {
		let okAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
			self.dismissViewControllerAnimated(true, completion: nil)
		})
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
		alert.addAction(okAction)
		self.presentViewController(alert, animated: true, completion: nil)
		textField.becomeFirstResponder()
	}
	
}
