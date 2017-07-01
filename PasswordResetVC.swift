//
//  PasswordResetVC.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 27/06/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetVC: UIViewController {

    @IBOutlet weak var TextfieldOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBOutlet weak var InfoLabel: UILabel!

    @IBAction func Cancel(_ sender: AnyObject) {
        
          dismiss(animated: true, completion: nil)
    }

    @IBAction func ViewPressed(_ sender: AnyObject) {
        
          dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ResetPressed(_ sender: AnyObject) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: TextfieldOutlet.text!, completion: { (error:Error?) in
            if error != nil {
                self.InfoLabel.text = "Email not found"
           
            } else
            {
                self.InfoLabel.text = "Verificationd sent"
            }
        })
    }
    }



