//
//  UIBarButtonItem+RxExt.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/25/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit
import RxSwift


extension UIBarButtonItem {

    func rx_tap() -> Observable<Void> {
        return AnonymousObservable { observer in
            let target = BarButtonItemTarget(barButtonItem: self) {
                sendNext(observer, ())
            }
            return target
        }
    }
}


@objc
class BarButtonItemTarget: Disposable {
    
	typealias Callback = () -> Void
	weak var barButtonItem: UIBarButtonItem?
    var callback: Callback?
    
    init(barButtonItem: UIBarButtonItem, callback: () -> Void) {
        self.barButtonItem = barButtonItem
        self.callback = callback
        barButtonItem.target = self
        barButtonItem.action = Selector("action:")
    }
    
    deinit {
        dispose()
    }
    
    func dispose() {
        barButtonItem?.target = nil
        barButtonItem?.action = nil
		callback = nil
    }
    
    func action(sender: AnyObject) {
		if let callback = callback {
			callback()
		}
    }
    
}
