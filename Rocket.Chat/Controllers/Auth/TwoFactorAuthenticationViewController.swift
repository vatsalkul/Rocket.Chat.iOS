//
//  TwoFactorAuthenticationViewController.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 30/03/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit
import SwiftyJSON

final class TwoFactorAuthenticationViewController: BaseViewController {

    internal var requesting = false

    var username: String = ""
    var password: String = ""
    var token: String = ""

    @IBOutlet weak var viewFields: UIView! {
        didSet {
            viewFields.layer.cornerRadius = 4
            viewFields.layer.borderColor = UIColor.RCLightGray().cgColor
            viewFields.layer.borderWidth = 0.5
        }
    }

    @IBOutlet weak var visibleViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldCode: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldCode.text = token
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )

        if token.isEmpty {
            textFieldCode.becomeFirstResponder()
        } else {
            authenticate()
        }
    }

    func startLoading() {
        textFieldCode.alpha = 0.5
        requesting = true
        activityIndicator.startAnimating()
        textFieldCode.resignFirstResponder()
    }

    func stopLoading() {
        textFieldCode.alpha = 1
        requesting = false
        activityIndicator.stopAnimating()
    }

    // MARK: Keyboard Handlers
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            visibleViewBottomConstraint.constant = keyboardSize.height
        }
    }

    override func keyboardWillHide(_ notification: Notification) {
        visibleViewBottomConstraint.constant = 0
    }

    // MARK: Request username
    fileprivate func authenticate() {
        startLoading()

        func presentErrorAlert(message: String? = nil) {
            Alert(
                title: localized("error.socket.default_error.title"),
                message: message ?? localized("error.socket.default_error.message")
            ).present()
        }

        AuthManager.auth(username, password: password, code: textFieldCode.text ?? "") { [weak self] (response) in
            self?.stopLoading()
            
            switch response {
            case .resource(let resource):
                if let error = resource.error {
                    return presentErrorAlert(message: error)
                }
                
                self?.dismiss(animated: true, completion: nil)
                AppManager.reloadApp()
            case .error:
                presentErrorAlert()
            }
        }
    }

}

extension TwoFactorAuthenticationViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !requesting
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        authenticate()
        return true
    }

}
