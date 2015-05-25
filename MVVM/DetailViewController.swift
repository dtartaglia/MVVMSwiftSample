//
//  AddViewController.swift
//  MVVM
//
//  Created by carlos on 8/4/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class DetailViewController: UIViewController, DetailViewModelDelegate {
    
    var viewModel: DetailViewModel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    deinit {
        disposeBag.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
        nameField.text = viewModel.name
        amountField.text = viewModel.amount
        nameField.becomeFirstResponder()
        
        resultLabel.rx_subscribeTextTo(self.viewModel.infoText)
            >- disposeBag.addDisposable
        
        nameField.rx_observerEditingChanged()
            >- subscribeNext { value in
                self.viewModel.name = value
            } >- disposeBag.addDisposable
        
        amountField.rx_observerEditingChanged()
            >- subscribeNext { value in
                self.viewModel.amount = value
            }
            >- disposeBag.addDisposable
        
        cancelBarButtonItem.rx_tap()
            >- subscribeNext {
                self.navigationController?.popViewControllerAnimated(true)
            }
            >- disposeBag.addDisposable
        
        doneBarButtonItem.rx_tap()
            >- subscribeNext {
                self.viewModel.handleDonePressed()
            }
            >- disposeBag.addDisposable
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        disposeBag.dispose()
    }
    
    // MARK: - AddViewModelDelegate
    
    func showInvalidName() {
        UIAlertView(title: "Error", message: "Invalid name", delegate: nil, cancelButtonTitle: "OK").show()
        nameField.becomeFirstResponder()
    }
    
    func showInvalidAmount() {
        UIAlertView(title: "Error", message: "Invalid amount", delegate: nil, cancelButtonTitle: "OK").show()
        amountField.becomeFirstResponder()
    }
    
    func dismissAddView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
