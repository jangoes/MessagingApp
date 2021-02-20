//
//  Utils.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/19/21.
//

import UIKit

extension UserDefaults {
    private enum Keys {
        static let loginId = "loginId"
        static let username = "username"
    }
    
    class var loginId: String? {
        get {
            return self.standard.string(forKey: Keys.loginId)
        }
        set {
            self.standard.set(newValue, forKey: Keys.loginId)
        }
    }
    
    class var isLoggedIn: Bool {
        get {
            if let id = self.loginId, !id.isEmpty {
                return true
            }
            
            return false
        }
    }
    
    class var username: String? {
        get {
            return self.standard.string(forKey: Keys.username)
        }
        set {
            self.standard.set(newValue, forKey: Keys.username)
        }
    }
    
    func clear() {
        guard let domainName = Bundle.main.bundleIdentifier else {
            return
        }
        
        removePersistentDomain(forName: domainName)
        synchronize()
    }
}
