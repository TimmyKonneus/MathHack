//
//  ScoreboardTableViewController.swift
//  
//
//  Created by TIMMY KONNEUS on 04/06/17.
//
//

import UIKit
import Firebase


class ScoreboardTableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    
    //var postData = [String]()
    
    var users = [User]()
    
    /*var refHandle: UInt!
    var HighscoreList = [Highscore]()*/
    var cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        
         fetchHighscore()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(Back))
    }

    func Back() {
        
        self.navigationController?.isNavigationBarHidden = true
        performSegue(withIdentifier: "BackToMain", sender: navigationItem.leftBarButtonItem)
        
    }
    

    func fetchHighscore() {

     
        FIRDatabase.database().reference().child("users").queryOrdered(byChild: "neghighscore").queryLimited(toFirst: 20).observe(.childAdded, with: { (snapshot) in
        
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
 
                
    user.email = dictionary["email"] as! String?
                
    
    user.highscore = dictionary["highscore"] as! Int?
                   print(user.highscore)
                
                self.users.append(user)
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            }, withCancel: nil)
        
       
        
        
    }
    
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HSCell", for: indexPath)
        
        
        
        let user = users[indexPath.row]
        
        
        
        cell.textLabel?.text = String(describing: user.highscore!)
        
        cell.detailTextLabel?.text = user.email
     
        
        return cell
    }
    
   

}
