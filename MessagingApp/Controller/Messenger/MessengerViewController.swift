//
//  MessengerViewController.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/20/21.
//

import UIKit
import RxSwift
import RxCocoa

class MessengerViewController: UIViewController {
        
    deinit {
        removeObservers()
    }
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var messageTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var footerViewBottom: NSLayoutConstraint!
    
    lazy var bag = DisposeBag()
    let viewModel = MessageViewModel()
    var messageList = [Message]()
    weak var delegate: MainTapAction?
    
    static func instantiate() -> MessengerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "messengerVC") as! MessengerViewController
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Chat app"
        self.hideKeyboardWhenTappedAround()
        
        // - set delegate
        messageText.delegate = self
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // - tableview settings
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        messageTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        messageTableView.estimatedRowHeight = 121
        messageTableView.rowHeight = UITableView.automaticDimension
        
        // - add observers
        addObservers()
        
        // - adjust display
        modifyViews()
        
        // - Observers
        rxObservers()
        
        // - Logout
        logoutSetup()
    }
    
    func modifyViews() {
        messageText.textColor = .lightGray
        messageText.layer.cornerRadius = 5
        sendButton.layer.cornerRadius = 5
        
        messageTableView.separatorStyle = .none
        messageTableView.allowsSelection = false
    }
    
    func rxObservers() {
        messageText.rx.text.map { $0 ?? "" }.bind(to: viewModel.messageTextPublishSubject).disposed(by: bag)
        viewModel.isValid().bind(to: sendButton.rx.isEnabled).disposed(by: bag)
        viewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: sendButton.rx.alpha).disposed(by: bag)
        
        viewModel.messageObserver().subscribe { messages in
            if let msgs = messages.element {
                self.messageList = msgs
                self.messageTableView.reloadData()
            }
        }
        .disposed(by: bag)
        
        sendButton.rx.tap.asObservable()
            .subscribe { _ in
                if let msg = self.messageText.text, let name = UserDefaults.username, let id = UserDefaults.loginId {
                    if self.messageText.textColor != UIColor.lightGray {
                        let newMessage = SendMessage(id: id, name: name, message: msg)
                        self.sendButton.isEnabled = false
                        
                        self.viewModel.sendNew(newMessage) { isSuccess in
                            if isSuccess {
                                self.messageText.text = ""
                                self.textViewDidChange(self.messageText)
                                self.textViewDidEndEditing(self.messageText)
                                self.sendButton.isEnabled = true
                            } else {
                                self.sendButton.isEnabled = true
                            }
                        }
                    }
                }
            } .disposed(by: bag)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func logoutSetup() {
        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 15))
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 15)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .darkGray
        logoutButton.addTarget(self, action: #selector(self.action(sender:)), for: .touchUpInside)
        logoutButton.layer.cornerRadius = 5
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                UIView.animate(withDuration: duration) {
                    self.footerViewBottom.constant = -keyboardHeight
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification){
        if let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.footerViewBottom.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func action(sender: UIBarButtonItem) {
        UserDefaults.standard.clear()
        delegate?.render(display: .register)
    }
}
