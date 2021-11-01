//
//  ConversationViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit
import Firebase
import FirebaseDatabase

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
