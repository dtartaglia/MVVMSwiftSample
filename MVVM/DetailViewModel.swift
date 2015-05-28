//
//  DetailViewModel.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/27/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import Foundation
import RxSwift


struct DetailViewModel {

	init() {
		title = "New Payback"
		index = nil
		payback = Payback()
	}

	init(payback: Payback, atIndex index: Int) {
		title = "Edit Payback"
		self.index = index
		self.payback = payback
	}

	let index: Int?
	var canceled = false
	var payback = Payback()

	let title: String
	let invalidNameMessage = "Invalid name. Must be at least first and last."
	let invalidAmountMessage = "Invalid amount. Must be some amount greater than zero."

	var nameText: String? {
		if count(payback.firstName) > 0 || count(payback.lastName) > 0 {
			return payback.firstName + " " + payback.lastName
		}
		else {
			return nil
		}
	}

	var amountText: String? {
		if payback.amount != 0 {
			return NSString(format: "%0.2f", payback.amount) as String
		}
		else {
			return nil
		}
	}

	// static functions here for namespace reasons.
	static func convertStringToName(value: String?) -> (firstName: String, lastName: String) {
		var firstName = ""
		var lastName = ""
		if let value = value {
			let names = split(value) {$0 == " "}
			if names.count > 0 {
				firstName = names[0]
			}
			if names.count > 1 {
				lastName = " ".join(names[1 ..< names.count])
			}
		}
		return (firstName, lastName)
	}

	static func convertStringToAmount(value: String?) -> Double {
		var result: Double = 0.0
		if let value = value {
			result = value.toDouble() ?? 0
		}
		return result
	}

	static func configureResultTextFromName(name: (firstName: String, lastName: String), amount: Double) -> String {
		return name.firstName + " " + name.lastName + "\n" + (NSString(format: "%0.2f", amount) as String)
	}

	static func nameValid(firstName: String, _ lastName: String) -> Bool {
		return firstName != "" && lastName != ""
	}

	static func amountValid(amount: Double) -> Bool {
		return amount > 0
	}
	
}
