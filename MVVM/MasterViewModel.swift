//
//  MasterViewModel.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/27/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import Foundation


struct TableViewModel {
	
	init(payback: Payback) {
		self.payback = payback
	}
	var textLabelText: String {
		let singleLetter = payback.lastName.substringToIndex(payback.lastName.startIndex.successor())
		
		return "\(payback.firstName) \(singleLetter)."
	}
	
	var detailTextLabelText: String {
		return NSString(format: "$%.0f", round(payback.amount)) as String
	}
	
	private let payback: Payback
}

struct MasterTableViewModel {
	
	var paybackCollection = PaybackCollection()
	var selectedRow: Int?
	
	var rowCount: Int {
		return paybackCollection.paybacks.count
	}
	
	func tableViewModelForIndex(index: Int) -> TableViewModel {
		return TableViewModel(payback: paybackCollection.paybacks[index])
	}
	
	mutating func removePaybackAtIndex(index: Int) {
		paybackCollection.removePaybackAtIndex(index)
	}
	
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
