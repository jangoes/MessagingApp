//
//  IndexViewController.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/19/21.
//

import UIKit

class IndexViewController: UIViewController {
    
    weak var delegate: MainTapAction?
    
    static func instantiate() -> IndexViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! IndexViewController
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapSignUp(_ sender: Any) {
        delegate?.render(display: .register)
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        delegate?.render(display: .login)
    }
}
