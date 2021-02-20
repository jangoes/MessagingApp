//
//  AccountViewModel.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/19/21.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase

class AccountViewModel {
    
    private let database = Database.database().reference()
    
    let account: Account
    
    init(username: String, password: String) {
        self.account = Account(username: username, password: password)
    }
    
    func doRegister() -> Observable<String> {
        return Observable.create { observer in
            self.writeUserData(with: self.account.username, password: self.account.password) { error, authId in
                if let err = error {
                    observer.on(.error(err))
                } else {
                    observer.on(.next(authId))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func writeUserData(with username: String, password: String, completion: @escaping (Error?, String) -> ()) {
        let userObject: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        let newUser = database.child("users").childByAutoId()
        newUser.setValue(userObject) { error, dbRef in
            if error == nil {
                UserDefaults.loginId = newUser.key
                UserDefaults.username = username
                
                completion(nil, newUser.key ?? "")
            } else {
                completion(error, "")
            }
        }
    }
    
    func doLogin() -> Observable<String?> {
        return Observable.create { observer in
            self.authenticateUser(with: self.account.username, password: self.account.password) { authId in
                if let auid = authId {
                    observer.on(.next(auid))
                } else{
                    observer.on(.error(NSError(domain: "No user found", code: -1, userInfo: nil)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func authenticateUser(with username: String, password: String, completion: @escaping (String?) -> ()) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            for user in value {
                if let userInfos = user.value as? [String: String] {
                    if userInfos["username"] == username, userInfos["password"] == password {
                        UserDefaults.loginId = user.key
                        UserDefaults.username = username
                        
                        completion(user.key)
                        
                        return
                    }
                }
            }
            
            completion(nil)
        }
    }
}
