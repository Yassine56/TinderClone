//
//  UpdateViewController.swift
//  TinderLike
//
//  Created by Abouelouafa Yassine on 11/25/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var interestedUserSwitch: UISwitch!
    @IBOutlet var userGenderSwitch: UISwitch!
    @IBOutlet var profileImageView: UIImageView!
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        if let isInterestedInFemale = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedUserSwitch.setOn(isInterestedInFemale, animated: false)
        // Do any additional setup after loading the view.
    }
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground(block: { ( data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileImageView.image = image
                    }
                }
            })
        }
    }
    
    @IBAction func updateImageTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
             profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
        
        }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createWomen() {
        let imageUrls = ["https://si.wsj.net/public/resources/images/WW-AA695_SANDBE_GR_20160923125605.jpg","http://www.slate.com/content/dam/slate/blogs/xx_factor/2014/susan.jpg.CROP.promo-mediumlarge.jpg","http://wisetoast.com/wp-content/uploads/2015/10/Katherine-Elizabeth-Upton-most-beautiful-woman.jpg","https://cdn.cliqueinc.com/posts/196562/best-bras-ever-according-to-real-women-196562-1498068922755-main.480x480uc.jpg","http://cdn2-www.craveonline.com/assets/uploads/2016/12/Amazing-Women-on-Instagram-2017.jpg","https://www.wonderslist.com/wp-content/uploads/2016/10/Rachelle-Lefevre-hair-full.jpg","http://www.slate.com/content/dam/slate/articles/double_x/2017/05/170502_DX_working-Ivanka.jpg.CROP.promo-xlarge2.jpg","https://blog.blackbutterflybeautiful.com/wp-content/uploads/2017/07/3052ac71f8bd209087181a46f3fc032f.png"]
      var counter = 1
        
        for imageUrl in imageUrls {
            counter += 1
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFile(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    
                    user.password = "test"
                    user["isFemale"] = true
                    user["isInterestedInFemale"] = false
                    user.signUpInBackground(block: { (success, error) in
                        if success {
                            print("women user created")
                        }
                    })
                }
            }
        }
    }
    
    
    @IBAction func updateTapped(_ sender: Any) {
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedUserSwitch.isOn
       
        if let image = profileImageView.image {
           let imageData = UIImagePNGRepresentation(image)
            if let imageDatas = imageData{
           PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageDatas)
            }
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "update failed, try again"
                    if let err = error as NSError? {
                        if let detailError = err.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                }else {
                    print("update successful")
                    self.performSegue(withIdentifier: "segueToSwipe", sender: nil)
                }
            })
        }
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
