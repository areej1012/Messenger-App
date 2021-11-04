//
//  ConversationTableViewCell.swift
//  Messenger App
//
//  Created by administrator on 03/11/2021.
//

import UIKit
import SDWebImage
class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var lastMessage: UILabel!
   
  
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure( with model : Conversation){
        self.lastMessage.text = model.latestMessage.text
        self.name.text = model.name
       
        
        let filename = "\(model.otherUserUid)_profile_picture.png"
        let path = "images/"+filename
        StorageManager.shared.downloadURL(for: path, completion: {
            [weak self ] result in
            switch result{
            case.failure(let error):
                print("can't download \(error)")
            case .success(let url):
                DispatchQueue.main.async {
                    self?.imageProfile.sd_setImage(with: url, completed: nil)
                    self!.imageProfile.layer.cornerRadius = 20.0 //self!.imageProfile.frame.height / 2

                }
            }
            
        })
        
    }
}
