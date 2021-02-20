//
//  LoginController.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/18/21.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase

class AuthenticationViewController: UIViewController {
    
    fileprivate let bag = DisposeBag()
    
    weak var delegate: MainTapAction?
    
    var isSignup: Bool = false
        
    let usernameField: UITextField = {
        let field = UITextField()
        field.setLeftPaddingPoints(10)
        field.placeholder = "User name"
        field.backgroundColor = #colorLiteral(red: 0.9571688771, green: 0.9728072286, blue: 0.9837403893, alpha: 1)
        field.layer.cornerRadius = 5
        field.autocapitalizationType = .none
        
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.setLeftPaddingPoints(10)
        field.placeholder = "password"
        field.backgroundColor = #colorLiteral(red: 0.9571688771, green: 0.9728072286, blue: 0.9837403893, alpha: 1)
        field.layer.cornerRadius = 5
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        
        return field
    }()
    
    let buttonA: UIButton = {
        let buttonTitle =  "Login"
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.536103487, green: 0.8913286328, blue: 0.02797951177, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.setTitle(buttonTitle, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        
        return btn
    }()
    
    let buttonB: UIButton = {
        let buttonTitle =  "Sign up"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: #colorLiteral(red: 0.3646367192, green: 0.4274716973, blue: 0.4706953168, alpha: 1),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attribbutedTitle = NSMutableAttributedString(string: buttonTitle, attributes: titleAttributes)
        
        let btn = UIButton()
        btn.setAttributedTitle(attribbutedTitle, for: .normal)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
        return btn
    }()
    
    let invalidUsernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Value is incorrect"
        label.textColor = #colorLiteral(red: 0.6795449257, green: 0.2331626713, blue: 0.2335841358, alpha: 1)
        
        return label
    }()
    
    let invalidPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Value is incorrect"
        label.textColor = #colorLiteral(red: 0.6795449257, green: 0.2331626713, blue: 0.2335841358, alpha: 1)
        
        return label
    }()
    
    let agreementLabel: UILabel = {
        let agreementString = "By signing up, you agree to the Terms of Service and Privacy Policy, including Cookie Use. Others will be able to find you by searching for your email address or phone number when provided."
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: #colorLiteral(red: 0.3646367192, green: 0.4274716973, blue: 0.4706953168, alpha: 1),
            .kern: 1.5,
        ]
        
        let attributedString = NSMutableAttributedString(string: agreementString, attributes: textAttributes)
        
        let label = UILabel()
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Chat app"
        self.hideKeyboardWhenTappedAround()
        
        showDisplay() {
            self.addButtonAObserver()
        }
    }
        
    func addButtonAObserver() {
        buttonA.rx.tap.asObservable()
            .filter { (_) -> Bool in
                var errors = [ErrorCode]()
                
                if let username = self.usernameField.text {
                    if !username.isAlphanumeric {
                        errors.append(.invalidUsername)
                    } else if username.count < 8 || username.count > 16 {
                        errors.append(.invalidUsername)
                    }
                } else {
                    errors.append(.invalidUsername)
                }
                
                if let password = self.passwordField.text {
                    if !password.isAlphanumeric {
                        errors.append(.invalidPassword)
                    } else if password.count < 8 || password.count > 16 {
                        errors.append(.invalidPassword)
                    }
                } else {
                    errors.append(.invalidPassword)
                }
                
                if errors.isEmpty {
                    self.showDisplay()
                    return true
                } else {
                    self.showDisplay(with: errors)
                    return false
                }
            }
            .subscribe { _ in
                let viewModel = AccountViewModel(username: self.usernameField.text!, password: self.passwordField.text!)
                self.actionFor(viewModel)
            }
            .disposed(by: bag)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        delegate?.render(display: isSignup ? .login : .register)
    }
    
    func actionFor(_ model: AccountViewModel) {
        if self.isSignup {
            model.doRegister()
                .subscribe { authId in
                    print(authId)
                    self.delegate?.render(display: .messenger)
                } onError: { error in
                    print(error)
                } .disposed(by: self.bag)
        } else {
            model.doLogin()
                .subscribe { authId in
                    self.delegate?.render(display: .messenger)
                } onError: { error in
                    self.showDisplay(with: [.invalidUsername, .invalidPassword])
                } .disposed(by: self.bag)
        }
    }
    
}
