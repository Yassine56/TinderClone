//
//  MatchTableViewCell.swift
//  TinderLike
//
//  Created by Abouelouafa Yassine on 11/29/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Parse
class MatchTableViewCell: UITableViewCell {
    
    var reciepientObjectId = ""
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func sendTapped(_ sender: Any) {
       let message = PFObject(className: "Message")
       message["sender"] = PFUser.current()?.objectId
       message["receiver"] = reciepientObjectId
       message["content"] = messageTextField.text
       message.saveInBackground()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
