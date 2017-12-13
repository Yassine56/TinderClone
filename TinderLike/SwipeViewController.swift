//
//  ViewController.swift
//  TinderLike
//
//  Created by Abouelouafa Yassine on 11/21/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Parse
class SwipeViewController: UIViewController {

    
    @IBOutlet var matchImageView: UIImageView!
    var displayUserID = ""
    
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        print("logged out")
        PFUser.logOut()
        performSegue(withIdentifier: "SeguetoLogin", sender: nil)
    }
    

    @objc func  wasDragged(gestureRecognizer : UIPanGestureRecognizer)  {
       let labelPoint = gestureRecognizer.translation(in: view)
        matchImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x , y: view.bounds.height / 2 + labelPoint.y)
        let xfromCenter = view.bounds.width / 2 - matchImageView.center.x
        let scaler = min(abs(100 / xfromCenter), 1)
        let rotation = CGAffineTransform(rotationAngle: xfromCenter / 300)
        let scaledandrotated = rotation.scaledBy(x: scaler, y: scaler)
        matchImageView.transform = scaledandrotated
        
        if gestureRecognizer.state == .ended {
            var acceptedorrejected = ""
            if matchImageView.center.x < view.bounds.width / 2 - 100 {
                acceptedorrejected = "rejected"
                print(displayUserID)
                print("not interested")
            }
            if matchImageView.center.x > view.bounds.width / 2 + 100 {
                acceptedorrejected = "accepted"
                print("interested")
                print(displayUserID)
            }
            if acceptedorrejected != "" && displayUserID != "" {
                PFUser.current()?.addUniqueObject(displayUserID, forKey: acceptedorrejected)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateImage()
                    }
                })
            }
        matchImageView.center = CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2 )
        let rotations = CGAffineTransform(rotationAngle: 0)
        let scaledandrotateds = rotations.scaledBy(x: 1, y: 1)
        matchImageView.transform = scaledandrotateds
        
        }
        
    }
    
    
    
    func updateImage() {
        print("toto")
        let query = PFUser.query()
        query?.limit = 1
        
        if let isInterstedInWomen = PFUser.current()?["isInterestedInWomen"] {
        query?.whereKey("isFemale", equalTo: isInterstedInWomen)
        }
        if let isFemale = PFUser.current()?["isFemale"] {
            query?.whereKey("isInterestedInWomen", equalTo: isFemale)
        }
        
        var ignoredUsers = [String]()
        
        if let acceptedusers = PFUser.current()?["accepted"] as? [String]{
        for user in acceptedusers {
           ignoredUsers.append(user)
        }
        }
        if let rejectedusers = PFUser.current()?["rejected"] as? [String]{
        for user in rejectedusers  {
            ignoredUsers.append(user)
        }
        }
        if let geopoint = PFUser.current()?["location"] as? PFGeoPoint {
            query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geopoint.latitude - 1 , longitude: geopoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geopoint.latitude + 1 , longitude: geopoint.longitude + 1))
        }
        
        
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers )
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        if let imageFile = user["photo"] as? PFFile {
                            imageFile.getDataInBackground(block: { (data, error) in
                                if let imageData = data {
                                    self.matchImageView.image = UIImage(data: imageData)
                                    if let userid = user.objectId {
                                    self.displayUserID = userid
                                    }
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            if let geoPoint = point {
                PFUser.current()?["location"] = geoPoint
                PFUser.current()?.saveInBackground()
            }
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
          matchImageView.addGestureRecognizer(gesture)
        updateImage()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

