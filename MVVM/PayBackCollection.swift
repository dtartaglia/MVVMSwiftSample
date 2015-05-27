//
//  PayBackCollection.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/25/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import Foundation


struct PaybackCollection {
	
	private (set) var paybacks: [Payback] = []
	
	mutating func replacePayback(payBack: Payback, atIndex index: Int) {
		paybacks[index] = payBack
	}
	
	mutating func insertPayback(payback: Payback) {
		paybacks.insert(payback, atIndex: 0)
	}
}