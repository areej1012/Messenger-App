//
//  ConversationViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit
import Firebase
class ConversationViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    var user : UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        getDate()
   
        
       }
    

    func getDate(){
        print( "uid \(Auth.auth().currentUser?.uid)")
       if Auth.auth().currentUser?.uid == nil{
        let desCV = storyboard?.instantiateViewController(identifier: "nav") as! UINavigationController
                    desCV.modalPresentationStyle = .fullScreen
                    present(desCV, animated: false, completion: nil)
        }
       else {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(Auth.auth().currentUser?.displayName)
             Firestore.firestore().collection("User").document(uid).getDocument(completion: {
                 (document, error) in
                     if let document = document, document.exists {
                         do{
                         self.user = try document.data(as: UserModel.self)
                             self.name.text = "\(self.user!.FirstName) \(self.user!.LastName)"
                            
                         }
                         catch{
                             print("not work")
                         }
                     } else {
                        // if the decoment not in firebase then the user login using facebook
                        self.name.text = Auth.auth().currentUser!.displayName
                     }
                 
             })
             }
            
       }
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


