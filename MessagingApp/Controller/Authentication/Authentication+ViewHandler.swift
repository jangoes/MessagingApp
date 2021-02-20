//
//  Authentication+ViewHandler.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/20/21.
//

import UIKit

extension AuthenticationViewController {
    func showDisplay(with error: [ErrorCode]? = nil, _ completion: (() -> ())? = nil) {
        var isInvalidUsername = false
        var isInvalidPassword = false
        
        // - error checker
        if let errorValues = error {
            for err in errorValues {
                if err == .invalidUsername {
                    isInvalidUsername = true
                } else if err == .invalidPassword {
                    isInvalidPassword = true
                }
            }
        }
        
        // - offset handler
        var offSet: CGFloat = Screen.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0)
        
        // - Display setting for username
        usernameField.frame = CGRect(x: 15, y: offSet + 40, width: Screen.width - 30, height: 50)
        offSet = usernameField.frame.origin.y + usernameField.frame.size.height
        self.view.addSubview(usernameField)
        
        // - Display setting for username error
        if isInvalidUsername {
            invalidUsernameLabel.frame = CGRect(x: 15, y: offSet + 8, width: Screen.width - 30, height: 20)
            offSet = invalidUsernameLabel.frame.origin.y + invalidUsernameLabel.frame.size.height
            invalidUsernameLabel.isHidden = false
            self.view.addSubview(invalidUsernameLabel)
        } else {
            invalidUsernameLabel.isHidden = true
        }
        
        // - Display setting for password
        passwordField.frame = CGRect(x: 15, y: offSet + 25, width: Screen.width - 30, height: 50)
        offSet = passwordField.frame.origin.y + passwordField.frame.size.height
        self.view.addSubview(passwordField)
        
        // - Display setting for password error
        if isInvalidPassword {
            invalidPasswordLabel.frame = CGRect(x: 15, y: offSet + 8, width: Screen.width - 30, height: 20)
            offSet = invalidPasswordLabel.frame.origin.y + invalidPasswordLabel.frame.size.height
            invalidPasswordLabel.isHidden = false
            self.view.addSubview(invalidPasswordLabel)
        } else {
            invalidPasswordLabel.isHidden = true
        }
        
        // - Display setting for upper button
        buttonA.frame = CGRect(x: 15, y: offSet + 25, width: Screen.width - 30, height: 50)
        buttonA.setTitle(isSignup ? "Sign up" : "Login", for: .normal)
        offSet = buttonA.frame.origin.y + buttonA.frame.size.height
        self.view.addSubview(buttonA)
        
        // - Display setting for lower button
        buttonB.frame = CGRect(x: 15, y: offSet + 10, width: Screen.width - 30, height: 16)
        buttonB.updateAttributedText(isSignup ? "Login" : "Sign up")
        offSet = buttonB.frame.origin.y + buttonB.frame.size.height
        self.view.addSubview(buttonB)
        
        // - Display setting for agreementLabel
        agreementLabel.frame = CGRect(x: 15, y: offSet, width: Screen.width - 30, height: 150)
        self.view.addSubview(agreementLabel)
        
        // - completion
        if let doCompletion = completion {
            doCompletion()
        }
    }
}
