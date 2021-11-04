//
//  ProfileViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//
import Foundation
import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let name  = UserDefaults.standard.string(forKey: "name") else { return  }
        nameUser.text = name
        print("name in profile \(name)")
        
        SetImageProfile()
    }
    
    func SetImageProfile(){
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        let filename = "\(uid)_profile_picture.png"
        let path = "images/"+filename
        StorageManager.shared.downloadURL(for: path, completion: {
            [weak self ] result in
            switch result{
            case.failure(let error):
                print("can't download \(error)")
            case .success(let url):
                self?.downloadImage(url: url)
            }
            
        })
    }
    
    func downloadImage(url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: {
            [weak self] data, _, error in
            guard let data = data , error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self!.imageButton.setImage(image, for: .normal)
                self!.imageButton.imageView?.layer.cornerRadius = self!.imageButton.frame.height / 2
                self!.imageButton.imageView?.layer.borderWidth = 1
            }
           
            
        }).resume()
    }


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
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.synchronize()
        }
        catch{
            print(error)
        }
               }))
               actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                      present(actionSheet, animated: true)
       
    }
    
    
    
    @IBAction func SaveImage(_ sender: UIButton) {
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
