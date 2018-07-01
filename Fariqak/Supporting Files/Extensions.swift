//
//  Extensions.swift
//  Fariqak
//
//  Created by Esslam Emad on 16/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    
    func showAlert(error: Bool = true, withMessage message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: NSLocalizedString(error ? "Error" : "Success", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: completion)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow (_ notification:Notification) {
        view.bounds.origin.y = +getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide (_ notification: Notification){
        view.bounds.origin.y = 0
    }
    
    @objc func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

