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

		// this pipe takes what the user entered in the nameField and turns it into a (firstName, lastName) tuple
		let name = nameField.rx_text()
			>- startWith(viewModel.nameText)
			>- map { text in
				return DetailViewModel.convertStringToName(text)
		}

		// this pipe takes what the user entered in the amountField and turns it into a Double
		let amount = amountField.rx_text()
			>- startWith(viewModel.amountText)
			>- map { (text: String) -> Double in
				return DetailViewModel.convertStringToAmount(text)
		}

		// this pipe combines name and amount, configures them into pretty text and pushes the result to the resultLabel
		combineLatest(name, amount) { name, amount in
			return DetailViewModel.configureResultTextFromName(name, amount: amount)
			}
			>- resultLabel.rx_subscribeTextTo
			>- disposeBag.addDisposable

		// this pipe watches for doneBarButtonItem taps, or if the user taps return while in the amount field, and calls the doneAction if either of these events happen
		combineLatest(name, amount) { ($0, $1) }
			>- sampleLatest(merge(returnElements(doneBarButtonItem.rx_tap(), amountField.rx_controlEvents(.EditingDidEndOnExit))))
			>- subscribeNext { [weak self] name, amount in
				self!.doneAction(name: name, amount: amount)
			}
			>- disposeBag.addDisposable

		// this pipe moves the curser from the nameField to the amountField when the user taps return while in the nameField
		nameField.rx_controlEvents(.EditingDidEndOnExit)
			>- subscribeNext { [weak self] in
				self!.amountField.becomeFirstResponder()
			}
			>- disposeBag.addDisposable

		// this pipe handles exiting if the user taps the cancelBarButtonItem
		cancelBarButtonItem.rx_tap()
			>- subscribeNext { [weak self] _ in
				self!.viewModel.canceled = true
				self!.performSegueWithIdentifier("Unwind", sender: self!)
			}
			>- disposeBag.addDisposable
	}

	func doneAction(# name: (firstName: String, lastName: String), amount: Double) {
		if !DetailViewModel.nameValid(name.firstName, name.lastName) {
			warnUser(DetailViewModel.invalidNameMessage, aboutTextField: nameField)
		}
		else if !DetailViewModel.amountValid(amount) {
			warnUser(DetailViewModel.invalidAmountMessage, aboutTextField: amountField)
		}
		else {
			viewModel.updatePayback(name: name, amount: amount)
			performSegueWithIdentifier("Unwind", sender: self)
		}
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
