//
//  DataModel.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/18/21.
//

import Foundation

struct User {
    let name: String
    let loginId: String
}

struct Account {
    let username: String
    let password: String
}

struct Message {
    let name: String
    let message: String
    let type: SenderType
    let time: Double
}

struct SendMessage {
    let id: String
    let name: String
    let message: String
}

enum SenderType: Int {
    case own = 1
    case others = 0
}

enum RenderView {
    case index
    case login
    case register
    case messenger
}

enum ErrorCode: Int {
    case invalidUsername
    case invalidPassword
}

enum DatabaseReference: String {
    case users
    case messages
}

enum ArrowDirection {
    case left
    case right
}
