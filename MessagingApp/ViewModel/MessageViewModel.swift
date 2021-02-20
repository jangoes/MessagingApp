//
//  MessageViewModel.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/20/21.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseDatabase

class MessageViewModel {
    private let database = Database.database().reference()
    
    let messageTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        messageTextPublishSubject.asObservable()
            .map { textString in
                return textString.count > 0 || textString == "Start a new message"
            }
    }
    
    func messageObserver() -> Observable<[Message]> {
        return Observable.create { observer in
            let reference = self.database.child("messages")
            
            reference.observe(.value) { snapshot in
                guard let value = snapshot.value as? [String: Any] else {
                    return
                }
                
                var messageList = [Message]()
                
                for messages in value {
                    if let userInfos = messages.value as? [String: Any] {
                        let id = userInfos["senderId"] as? String ?? ""
                        let message = userInfos["message"] as? String ?? ""
                        let name = userInfos["name"] as? String ?? ""
                        let time = userInfos["time"] as? Double ?? 0
                        
                        if !id.isEmpty {
                            let sender: SenderType = id == UserDefaults.loginId ? .own : .others
                            let msg = Message(name: name, message: message, type: sender, time: time)
                            
                            messageList.append(msg)
                        }
                    }
                }
                
                observer.on(.next(messageList.sorted { $0.time > $1.time }))
            }
            
            return Disposables.create()
        }
    }
    
    func sendNew(_ message: SendMessage, _ completion: @escaping  (Bool) -> ()) {
        let current = Date()
        let timeInterval = current.timeIntervalSince1970
        
        let messageObject: [String: Any] = [
            "senderId": message.id,
            "message": message.message,
            "name": message.name,
            "time": timeInterval
        ]
        
        let newUser = database.child("messages").childByAutoId()
        newUser.setValue(messageObject) { error, dbRef in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
