//
//  Extension.swift
//  Messenger App
//
//  Created by administrator on 31/10/2021.
//

import Foundation
import UIKit

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           // take a photo or select a photo
       
           // action sheet - take photo or choose photo
           picker.dismiss(animated: true, completion: nil)
           print(info)
           
           guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
               return
           }
        ImageButton.setImage(selectedImage, for: .normal)
        
           
       }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
}
