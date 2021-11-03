//
//  Conversation.swift
//  Messenger App
//
//  Created by administrator on 03/11/2021.
//

import Foundation
struct Conversation {
    var id : String
    var name : String
    var otherUserUid : String
    var latestMessage : LatestMessage
}
struct LatestMessage {
    var data : String
    var text : String
    var isRead : Bool
}
