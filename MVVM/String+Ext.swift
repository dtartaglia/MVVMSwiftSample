//
//  String+Ext.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/27/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import Foundation


extension String {
	public func toDouble() -> Double? {
		return NSNumberFormatter().numberFromString(self)?.doubleValue
	}
}
