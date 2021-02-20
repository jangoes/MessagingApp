//
//  AppCoordinator.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/18/21.
//

import UIKit

protocol MainTapAction: AnyObject {
    func render(display: RenderView)
}

class AppCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let renderValue: RenderView = UserDefaults.isLoggedIn ? .messenger : .index
        render(display: renderValue)
    }
}

extension AppCoordinator: MainTapAction {
    func render(display: RenderView) {
        var nav = UINavigationController()
        
        switch display {
            case .index:
                let viewController = IndexViewController.instantiate()
                viewController.delegate = self
                nav = UINavigationController(rootViewController: viewController)
                nav.setNavigationBarHidden(true, animated: false)
                break
            case .login:
                let viewController = AuthenticationViewController()
                viewController.isSignup = false
                viewController.delegate = self
                nav = UINavigationController(rootViewController: viewController)
                break
            case .register:
                let viewController = AuthenticationViewController()
                viewController.isSignup = true
                viewController.delegate = self
                nav = UINavigationController(rootViewController: viewController)
                break
            case .messenger:
                let viewController = MessengerViewController.instantiate()
                viewController.delegate = self
                nav = UINavigationController(rootViewController: viewController)
                break
        }
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
