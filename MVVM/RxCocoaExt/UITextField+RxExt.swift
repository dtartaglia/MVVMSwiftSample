//
//  UITextField+RxExt.swift
//  MVVM
//
//  Created by Daniel Tartaglia on 5/25/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import Foundation
import RxSwift



extension UITextField {
    
    func rx_observerEditingChanged() -> Observable<String> {
        return AnonymousObservable { observer in
            MainScheduler.ensureExecutingOnScheduler()
            
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
    
    weak var control: UITextField?
    let callback: () -> Void
    
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
    }
    
    func action(sender: AnyObject!) {
        callback()
    }
}