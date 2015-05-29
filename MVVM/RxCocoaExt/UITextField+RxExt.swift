//
//  UITextField+RxExt.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/25/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit
import RxSwift



extension UITextField {
    
    func rx_textChanged() -> Observable<String> {
        return AnonymousObservable { observer in
            let target = ControlTarget(control: self) {
                sendNext(observer, self.text)
            }
            return target
        }
    }
}

// this must be a public ObjC class for it to be visible to the ObjC runtime.
@objc
class ControlTarget: Disposable {

	typealias Callback = () -> Void
    weak var control: UITextField?
    var callback: Callback?
    
    init(control: UITextField, callback: () -> Void) {
        self.control = control
        self.callback = callback
        control.addTarget(self, action: "action:", forControlEvents: .EditingChanged)
    }
    
    deinit {
        dispose()
    }
    
    func dispose() {
        control?.removeTarget(self, action: "action:", forControlEvents: .EditingChanged)
		callback = nil
    }
    
    func action(sender: AnyObject) {
		if let callback = callback {
			callback()
		}
    }
}
