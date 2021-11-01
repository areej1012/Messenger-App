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
            
            database.child(user.Uid).setValue(["first_name":user.firstName,"last_name":user.lastName, "email": user.emailAddress]
            )
        }
}
    

    struct ChatAppUser {
        let firstName: String
        let lastName: String
        let emailAddress: String
        
        
        var Uid: String {
            Auth.auth().currentUser!.uid
        }
    }
