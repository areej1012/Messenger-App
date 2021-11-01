//
//  UserModel.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserModel : Codable, Identifiable {
 @DocumentID var id : String?
    var Email: String
    var FirstName: String
    var LastName : String
    var ImageProfile: String
    

    
}
