//
//  ProfileViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit

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
        UserDefaults.standard.removeObject(forKey: "logged_in")
        let desCV = storyboard?.instantiateViewController(identifier: "nav") as! UINavigationController
        desCV.modalPresentationStyle = .fullScreen
        present(desCV, animated: false, completion: nil)
    }
}
