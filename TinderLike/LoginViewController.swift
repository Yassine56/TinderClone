//
//  LoginViewController.swift
//  TinderLike
//
//  Created by Abouelouafa Yassine on 11/24/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {
    var loginMode = true
    @IBOutlet var loginsingupButton: UIButton!
    @IBOutlet var password: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var changeloginsignupButton: UIButton!
    @IBAction func loginSignupTaped(_ sender: Any) {
        if loginMode == false {
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            user.signUpInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "sign up failed, try again"
                    if let err = error as NSError? {
                        if let detailError = err.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                }else {
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                    print("sign up successful")
                }
            })
        }else {
            if let usernam = username.text {
                if let passwor = password.text {
                    PFUser.logInWithUsername(inBackground: usernam, password: passwor, block: { (user, error) in
                        if error != nil {
                            var errorMessage = "log in failed, try again"
                            if let err = error as NSError? {
                                if let detailError = err.userInfo["error"] as? String {
                                    errorMessage = detailError
                                }
                            }
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                        }else {
                            print("log in successful")
                            if PFUser.current() != nil {
                                if PFUser.current()?["isFemale"] != nil {
                                    self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
                                }else {
                                    
                                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                                }
                            }
                        }
                         })
                }
            }
            
           
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            if PFUser.current()?["isFemale"] != nil {
                self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
            }else {
            
            self.performSegue(withIdentifier: "updateSegue", sender: nil)
            }
        }
    }
    @IBAction func changeLoginSignUpTapped(_ sender: Any) {
        if loginMode == true {
            loginsingupButton.setTitle("Sign up", for: .normal)
            changeloginsignupButton.setTitle("Log in", for: .normal)
            loginMode = false
        } else {
            loginsingupButton.setTitle("Log in", for: .normal)
            changeloginsignupButton.setTitle("Sign up", for: .normal)
            loginMode = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
