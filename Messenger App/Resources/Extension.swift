//
//  Extension.swift
//  Messenger App
//
//  Created by administrator on 31/10/2021.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           // take a photo or select a photo
       
           // action sheet - take photo or choose photo
           picker.dismiss(animated: true, completion: nil)
           print(info)
           
           guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
               return
           }
      
        ImageButton.setImage(selectedImage, for: .normal)
        ImageButton.imageView?.layer.cornerRadius = ImageButton.frame.height / 2
        ImageButton.imageView?.layer.borderWidth = 1
        
           
       }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
}

extension ConversationViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationTableViewCell
        let model = conversation[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    // when user taps on a cell, we want to push the chat screen onto the stack
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           let user = conversation[indexPath.row]
           let vc =   ChatViewController(uid: user.otherUserUid,id: user.id)
           vc.title = user.name
           vc.navigationItem.largeTitleDisplayMode = .never
           navigationController?.pushViewController(vc, animated: true)
       }
    
}



extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender{
            return sender
        }
        fatalError("the id sender is nil")
       
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}

extension ChatViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty  , let sender = self.selfSender , let messageId = createMessageId() else {

               return
           }
           
           print("sending \(text)")
          let message = Message(sender:sender, messageId: messageId, sentDate: Date(), kind: .text(text))

        if isNewConversation {
           // create convo in database
         // message ID should be a unique ID for the given message, unique for all the message
            // use random string or random number
             DatabaseManger.shared.createNewConversation(with: otherUserUid, name: self.title ?? "User", firstMessage: message) { [weak self] success in
                    if success {
                        print("message sent")
                        self?.isNewConversation = false
                    }else{
                        print("failed to send")
                    }
                }
        }
        else{
            // append to converstion is already threre
            guard let  ConversationID =  conversationId , let name = self.title else {
                return
            }
            DatabaseManger.shared.sendMessage(to: ConversationID, name: name, newMessage: message, completion: {
                succes in
                if succes {
                    print("send success")
                }
                else{
                    print("send Failed")
                }
            })
        }
        
    }
    private func createMessageId() -> String? {
            // date, otherUserEmail, senderEmail, randomInt possibly
            // capital Self because its static
        
            guard let currentUserUid = UserDefaults.standard.value(forKey: "uid") as? String else {
                return nil
            }

            let dateString = Self.dateFormatter.string(from: Date())
            let newIdentifier = "\(otherUserUid)_\(currentUserUid)_\(dateString)"

            return newIdentifier
            
        }
    
}



extension NewConversationViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard  let text = searchBar.text , !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()
        spinner.show(in: view)
        search(text: text)
    }
    
    func search(text : String){
        if isFetch{
            // is true then filter
            searchUser(term: text)
        }
        else{
            // get all user from colloction users and store in users array
            DatabaseManger.shared.getAllUsers(completion: { [weak self] result in
                switch result{
                case .success(let usersCollocation):
                    self?.isFetch = true
                    self?.users = usersCollocation
                    self?.searchUser(term: text)
                case .failure(let error):
                    print(error)
                
                }
                
            })
        }
    }
    // use to get the user that user want chat with him
    func searchUser(term: String){
        guard isFetch else {
            return
        }
        spinner.dismiss()
        
        let result : [[String:String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased()  else{
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        self.results = result
  
        UIUpdate()
       
    }
    func UIUpdate(){
        if results.isEmpty{
            NoResult.isHidden = false
            tableview.isHidden = true
        }
        else{
            NoResult.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
        }
    }
}
extension NewConversationViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let dataUser = results[indexPath.row]
        dismiss(animated: true, completion: {
            self.completion?(dataUser)
        })
    }
    
}


extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           // take a photo or select a photo
       
           // action sheet - take photo or choose photo
           picker.dismiss(animated: true, completion: nil)
           print(info)
           
           guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
               return
           }
        
        imageButton.setImage(selectedImage, for: .normal)
        imageButton.imageView?.layer.cornerRadius = imageButton.frame.height / 2
        imageButton.imageView?.layer.borderWidth = 1
        
      
        
           
       }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
}



