//
//  ConversationViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
   
           let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
           if !isLoggedIn {
               // present login view controller
               
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
