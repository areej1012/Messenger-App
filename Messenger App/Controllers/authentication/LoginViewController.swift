//
//  ViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var GoogleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func userAuthentication(_ sender: UIButton) {
       UserDefaults.standard.set(true, forKey: "logged_in")
        
        dismiss(animated: false, completion: nil)
        
        
        
    }
    
}

