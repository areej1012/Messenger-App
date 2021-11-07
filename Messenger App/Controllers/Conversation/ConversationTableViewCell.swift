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
   
    
    @IBOutlet weak var dateMessage: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageProfile.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        imageProfile.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageProfile.layer.cornerRadius = imageProfile.bounds.height / 2
        imageProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure( with model : Conversation){
        self.lastMessage.text = model.latestMessage.text
        self.name.text = model.name
        self.dateMessage.text = changeFormat(date: model.latestMessage.data)
        
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
                 

                }
            }
            
        })
        
    }
    
    func changeFormat(date: String) -> String{
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        formatter1.timeStyle = .long
        formatter1.locale = .current
        let NewDate = formatter1.date(from: date)
     
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // "a" prints "pm" or "am"
  
        let hourString = formatter.string(from: NewDate!) // "12 AM"
        return hourString

    }
}
