//
//  MatchesViewController.swift
//  
//
//  Created by Abouelouafa Yassine on 11/29/17.
//

import UIKit
import Parse
class MatchesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var messages = [String]()
    var images = [UIImage]()
    var userArray = [String]()
    
    @IBOutlet var tableView: UITableView!
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String]{
            query.whereKey("objectId", containedIn: acceptedPeeps)
            }
            query.findObjectsInBackground(block: { (objects, error) in
                if let users = objects {
                    for user in users {
                        if let theUser = user as? PFUser {
                            if let photoFile = theUser["photo"] as? PFFile {
                                photoFile.getDataInBackground(block: { (data, error) in
                                    if let datata = data {
                                        if let image = UIImage(data: datata) {
                                        
                                            if let objectid = theUser.objectId {
                                                
                                                
                                                let messageQuery = PFQuery(className: "Message")
                                                messageQuery.whereKey("receiver", equalTo: PFUser.current()?.objectId as Any)
                                                messageQuery.whereKey("sender", equalTo: objectid)
                                                
                                                messageQuery.findObjectsInBackground(block: { (objects, error) in
                                                    var messagetext = "no message from this user"
                                                    if let objects = objects {
                                                        for object in objects {
                                                            if let message = object["content"] as? String{
                                                                messagetext = message
                                                            }
                                                           
                                                        }
                                                        
                                                    }
                                                    self.messages.append(messagetext)
                                                    self.userArray.append(objectid)
                                                    self.images.append(image)
                                                    self.tableView.reloadData()
                                                })
                                                
                                                
                                                
                                            }
                                        }
                                    }
                                })
                            }
                        }
                        
                    }
                }
            })
        }
        
  
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MatchTableViewCell {
            cell.messageLabel.text = "you didn't receive a message yet"
            cell.imageView?.image = images[indexPath.row]
            cell.reciepientObjectId = userArray[indexPath.row]
            cell.messageLabel.text = messages[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
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
