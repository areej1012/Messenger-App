//
//  ProfileViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func LogOut(_ sender: Any) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
               
               actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
                   // action that is fired once selected
                   
                   guard let strongSelf = self else {
                       return
                   }
               
        do{
      try  Auth.auth().signOut()
            let desCV = self!.storyboard?.instantiateViewController(identifier: "nav") as! UINavigationController
            desCV.modalPresentationStyle = .fullScreen
            self!.present(desCV, animated: false, completion: nil)
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.synchronize()
        }
        catch{
            print(error)
        }
               }))
               actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                      present(actionSheet, animated: true)
       
    }
}
