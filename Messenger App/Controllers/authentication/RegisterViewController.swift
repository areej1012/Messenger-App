//
//  RegisterViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
class RegisterViewController: UIViewController {
   @IBOutlet weak var ImageButton: UIButton!
    @IBOutlet weak var errorlbl: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageButton.imageView?.layer.cornerRadius = ImageButton.imageView!.frame.width / 2 
        ImageButton.layer.masksToBounds = true
        
        Email.layer.cornerRadius = 12
        Email.layer.borderWidth = 2
        Email.layer.borderColor = UIColor.lightGray.cgColor
        FirstName.layer.cornerRadius = 12
        FirstName.layer.borderWidth = 2
        FirstName.layer.borderColor = UIColor.lightGray.cgColor
        LastName.layer.cornerRadius = 12
        LastName.layer.borderWidth = 2
        LastName.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.cornerRadius = 12
        password.layer.borderWidth = 2
        password.layer.borderColor = UIColor.lightGray.cgColor
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
    
    func isPasswordValid(_ password : String) -> Bool {
       
       let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
       return passwordTest.evaluate(with: password)
   }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String?{
        if FirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        let checkPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(checkPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func addNewUser(_ sender: Any) {
     print("Cilcked")
        // Validate the fields
        let error = validateFields()
        if error != nil {
                   // There's something wrong with the fields, show error message
                   showError(error!)
               }
      else{
        let firstname = FirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = LastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = Email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        

            // create new user, so if the user enter email it's already exists
           // so will never create account in firebase Auth & firestore & Database
            Auth.auth().createUser(withEmail: email, password: password){
                reuslt, error in
                if error != nil {
                    self.showError("Your account is already exists")
                }
                else if let reuslt = reuslt {
                    // store the user in firestore with his info
                    let newUser = UserModel(Email: reuslt.user.email!, FirstName: firstname, LastName: lastname, ImageProfile: "")
                    
                    do{
                        let _ = try Firestore.firestore().collection("User").document(reuslt.user.uid).setData(from: newUser)
                        //create database for the user
                        
                        DatabaseManger.shared.insertUser(with: ChatAppUser(firstName: newUser.FirstName, lastName: newUser.LastName, emailAddress: newUser.Email))
                       
                        // Transition to the home screen
                            self.transitionToHome()
                    }
                    catch{
                        self.showError("Error Saving Data")
                    }


                }
            }
}


    }
    
       func transitionToHome() {
        let des = storyboard?.instantiateViewController(identifier: "Tab") as! UITabBarController
        des.modalPresentationStyle = .fullScreen
        present(des, animated: false, completion: nil)
           
       }
    func showError(_ message:String) {
        
        errorlbl.text = message
        errorlbl.alpha = 1
    }
    
    @IBAction func UploadImageOfUser(_ sender: UIButton) {
        presentPhotoActionSheet()
    }
    
    
    
    func presentPhotoActionSheet(){
         let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
             self?.presentCamera()
         }))
         actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
             self?.presentPhotoPicker()
         }))
         
         present(actionSheet, animated: true)
     }
    
    
    func presentCamera() {
          let imagePicker = UIImagePickerController()
          if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
          {
              imagePicker.sourceType = UIImagePickerController.SourceType.camera
              imagePicker.allowsEditing = true
              self.present(imagePicker, animated: true, completion: nil)
          }
          else
          {
              let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
      }
    
      func presentPhotoPicker() {
          let vc = UIImagePickerController()
          vc.sourceType = .photoLibrary
          vc.delegate = self
          vc.allowsEditing = true
          present(vc, animated: true)
      }
    
    

}

