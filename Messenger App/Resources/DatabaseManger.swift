//
//  DatabaseManger.swift
//  Messenger App
//
//  Created by administrator on 01/11/2021.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
final class DatabaseManger{
    
    static let shared = DatabaseManger()
    private let database = Database.database().reference()
    
    
}

extension DatabaseManger {
    public enum errorDatabase : Error{
        case failedTofech
    }
    
    public func userExists(with uid:String, completion: @escaping ((Bool) -> Void)) {

           database.child(uid).observeSingleEvent(of: .value) { snapshot in
               // snapshot has a value property that can be optional if it doesn't exist
               
               guard snapshot.value as? String != nil else {
                   // otherwise... let's create the account
                   completion(false)
                   return
               }
               
               // if we are able to do this, that means the email exists already!
               
               completion(true) // the caller knows the email exists already
           }
       }
         // Insert new user to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.Uid).setValue(["first_name":user.firstName,"last_name":user.lastName, "email": user.emailAddress])
            database.child("users").observeSingleEvent(of: .value, with: { snapchat in
            if var userCollection = snapchat.value as? [[String : String]]{
                // append user to dic
                let new =  ["name" : user.firstName + " " + user.lastName,
                            "email" : user.safeEmail,
                            "uid": user.Uid]
                userCollection.append(new)
                self.database.child("users").setValue(userCollection, withCompletionBlock: {
                    error, _ in
                    guard error == nil else{
                        return
                    }
                   
                })
            }
            else{
                //create user and save in array
                let newCollection : [[String:String]] = [
                    ["name" : user.firstName + " " + user.lastName,
                     "email" : user.safeEmail
                     ,"uid":user.Uid]
                ]
                self.database.child("users").setValue(newCollection, withCompletionBlock: {
                    error, _ in
                    guard error == nil else{
                        return
                    }
                   
                })
            }
            
        })

            
        }
    func getAllUsers(completion: @escaping (Result<[[String:String]], Error>)-> Void){
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
           guard let value = snapshot.value as? [[String : String]] else {
            completion(.failure(errorDatabase.failedTofech))
                return
            }
            completion(.success(value))
        })
        
    }
  
    
    public func createNewConversation(with otherUserUid: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") , let Myname = UserDefaults.standard.string(forKey: "name") else {
            return
        }
        let childUser = database.child(uid)
        childUser.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                //there is NO USER!!!!
                completion(false)
                debugPrint("there is no user")
                
                return
            }
            
            // set all keys that will need to create new conversation_
            let Id = "conversation_\(firstMessage.messageId)"
            
            
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch firstMessage.kind {
            case .text(let Message):
                message = Message
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let newConversation : [String:Any] = [
                "id":  Id,
                "other_user_uid": otherUserUid,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false,
                    
                ],
                
            ]
            
            let recipient_newConversationData: [String:Any] = [
                          "id": Id,
                          "other_user_uid": uid, // us, the sender email
                          "name": Myname,  // self for now, will cache later
                          "latest_message": [
                              "date": dateString,
                              "message": message,
                              "is_read": false,
                              
                          ],
                          
                      ]
                      // update recipient conversation entry
                      
            self.database.child("\(otherUserUid)/conversations").observeSingleEvent(of: .value) { [weak self] snapshot in
                          if var conversations = snapshot.value as? [[String: Any]] {
                              // append
                              conversations.append(recipient_newConversationData)
                              self?.database.child("\(otherUserUid)/conversations").setValue(Id)
                          }else {
                              // reciepient user doesn't have any conversations, we create them
                              // create
                              self?.database.child("\(otherUserUid)/conversations").setValue([recipient_newConversationData])
                          }
                      }
                      
                      
            
            
            // thers is User
            if var Conversation = userNode["conversation"] as? [[String: Any]]{
                // the user have Conversation so append to it
                
                Conversation.append(newConversation)
                childUser.setValue(userNode) { [weak self] error, _ in
                guard error == nil else {
                    completion(false)
                       return
                    
                }
                    self?.finishCreatingConversation(name: name, conversationID: Id, firstMessage: firstMessage, completion: completion)
              }

            }
            
            else{
                // the user don't have Conversation so add to it
                
              userNode["conversations"] = [
                           newConversation ]
                               
                childUser.setValue(userNode) { [weak self] error, _ in
                guard error == nil else {
                    completion(false)
                       return
                    
                }
                    self?.finishCreatingConversation(name: name, conversationID: Id, firstMessage: firstMessage, completion: completion)
              }
            }
        })
    }
    
    public func getAllConversations(for uid: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        
        database.child("\(uid)/conversations").observe(.value, with: {sanpshot in
           
            guard let value = sanpshot.value as? [[String:Any]] else {
                completion(.failure(errorDatabase.failedTofech))
                           return
                       }
            let conversations: [Conversation] = value.compactMap { dictionary in
                           guard let conversationId = dictionary["id"] as? String,
                                 let name = dictionary["name"] as? String,
                                 let otherUserUid = dictionary["other_user_uid"] as? String,
                                 let latestMessage = dictionary["latest_message"] as? [String: Any],
                                 let date = latestMessage["date"] as? String,
                                 let message = latestMessage["message"] as? String,
                                 let isRead = latestMessage["is_read"] as? Bool else {
                               return nil
                           }
                let latestMessageObject = LatestMessage(data: date, text: message, isRead: isRead)
                
                return Conversation(id: conversationId, name: name, otherUserUid: otherUserUid, latestMessage: latestMessageObject)
            }
          
            completion(.success(conversations))
        })
    }
    
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value) { snapshot in
            
                   // new conversation created? we get a completion handler called
                   guard let value = snapshot.value as? [[String:Any]] else {
                    completion(.failure(errorDatabase.failedTofech))
                       return
                   }
                   let messages: [Message] = value.compactMap { dictionary in
                       guard let name = dictionary["name"] as? String,
                       let isRead = dictionary["is_read"] as? Bool,
                       let messageID = dictionary["id"] as? String,
                       let content = dictionary["content"] as? String,
                       let senderUid = dictionary["sender_uid"] as? String,
                       let type = dictionary["type"] as? String,
                       let dateString = dictionary["date"] as? String,
                       let date = ChatViewController.dateFormatter.date(from: dateString)
                       else {
                           return nil
                       }
                       
                       let sender = Sender(photoURL: "", senderId: senderUid, displayName: name)
                       
                       return Message(sender: sender, messageId: messageID, sentDate: date, kind: .text(content))
                       
                   }
                   
                   completion(.success(messages))
                   
               }
    }
    
    public func sendMessage(to conversationID: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        
        self.database.child("\(conversationID)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard let strongSelf = self else {
                return
            }
            
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let messageDate = newMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            guard let uid = UserDefaults.standard.value(forKey: "uid") as? String else {
                completion(false)
                return
            }
            
            
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_uid": uid,
                "is_read": false,
                "name": name,
            ]
            
            currentMessages.append(newMessageEntry)
            
            strongSelf.database.child("\(conversationID)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
                
            }
        
        }
    
}
    
    private func finishCreatingConversation(name: String, conversationID:String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        var message = ""
              
         switch firstMessage.kind {
            case .text(let messageText):
                  message = messageText
            case .attributedText(_):
                  break
            case .photo(_):
                  break
            case .video(_):
                break
              case .location(_):
                  break
            case .emoji(_):
                  break
            case .audio(_):
                  break
            case .contact(_):
                  break
            case .linkPreview(_):
                  break
            case .custom(_):
                  break
              }
              
              
        guard let currentUserUid = UserDefaults.standard.string(forKey: "uid") else {
            completion(false)
            return
        }
        
        
       let collectionMessage: [String: Any] = [
         "id": firstMessage.messageId,
        "type": firstMessage.kind.messageKindString,
        "content": message,
        "date": dateString,
        "sender_uid": currentUserUid,
        "is_read": false,
        "name": name,
               ]
        
        
        let value: [String:Any] = [
                  "messages": [
                      collectionMessage
                  ]
              ]
              database.child("\(conversationID)").setValue(value) { error, _ in
                  guard error == nil else {
                      completion(false)
                      return
                  }
                  completion(true)
              }
              
          }
    }
    


    struct ChatAppUser {
        let firstName: String
        let lastName: String
        let emailAddress: String
        
        
        var Uid: String {
           return Auth.auth().currentUser!.uid
        }
        var safeEmail: String {
            var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
    }

