//
//  ViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController  {
    
    
  
    
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var GoogleButton: UIButton!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var facebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
                
    }

    @IBAction func userAuthentication(_ sender: UIButton) {
        // Firebase Login
        guard let email = email.text else {
            error.text = "The eamil is wrong or you're not register"
            return
        }
        guard let password = password.text else {
            error.text = "The pawword is wrong "
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(email)")
                return
            }
            let user = result.user
           
        })

 
        dismiss(animated: false, completion: nil)
        
        
        
    }
    
 
    @IBAction func signinFacebook(_ sender: Any) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: {
            result , error in
            if let error = error {
                        print("Failed to login: \(error.localizedDescription)")
                        return
                    }

            guard let accessToken = AccessToken.current else {
                        print("Failed to get access token")
                        return
                    }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                        if let error = error {
                            print("Login error: \(error.localizedDescription)")
                            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)

                            return
                        }
                if let user = user {
                    
                    self.dismiss(animated: false, completion: nil)

                }
        })
                
            
    })
        }
}

 


