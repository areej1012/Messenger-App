//
//  ChatViewController.swift
//  Messenger App
//
//  Created by administrator on 02/11/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView
class ChatViewController:  MessagesViewController  {
   
    
    public let otherUserUid: String
    public var conversationId: String?
    public var isNewConversation = false
    
    var senderPhotoe : URL?
    var otherPhote : URL?
    var messages = [Message]()
    var selfSender : Sender? {
        guard let uid =  UserDefaults.standard.string(forKey: "uid") , let name = UserDefaults.standard.string(forKey: "name") else {
            print("name")
           
            return nil
        }
    
       return Sender(photoURL: "", senderId: uid, displayName: name)
    }
    
      public static var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateStyle = .medium
          formatter.timeStyle = .long
          formatter.locale = .current
          return formatter
      }()
    
    init(uid:String, id: String?){
        self.conversationId = id
        self.otherUserUid = uid
        super.init(nibName: nil, bundle: nil)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   override func viewDidLoad() {
       super.viewDidLoad()
        
       // Do any additional setup after loading the view.

       messagesCollectionView.messagesDataSource = self
       messagesCollectionView.messagesLayoutDelegate = self
       messagesCollectionView.messagesDisplayDelegate = self
       messageInputBar.delegate = self

       
             
   }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId {
            listenForMessages(id:conversationId, shouldScrollToBottom: true)
        }

         
       }
     func listenForMessages(id: String,  shouldScrollToBottom: Bool) {
        
        DatabaseManger.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            switch result {
            case .success(let message):
                guard !message.isEmpty else {
                    return
                }
                self?.messages = message
               
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                }
            case .failure(let error):
                print("erorr get message for all converstion \(error)")
            }
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
