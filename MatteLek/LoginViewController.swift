//
//  LoginViewController.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 16/04/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit



class LoginViewController: UIViewController {
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var ResetButtonOutlet: UIButton!
   
    @IBOutlet weak var PasswordRepeat: UITextField!
    @IBOutlet weak var signInVertical: NSLayoutConstraint!
    @IBOutlet weak var HEIGHTPIC: NSLayoutConstraint!
    
    
    @IBOutlet weak var LoginOrRegister: UISegmentedControl!
    
    @IBOutlet weak var SignInButton: BounceButton!
    
  
    var ResetPressed:Bool = false
    var isSignIn:Bool = true
    var int = Int()
    var GlobalUID = String()
    var Data = String()
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        PasswordRepeat.alpha = 0
        PasswordRepeat.isUserInteractionEnabled = false
   
        ErrorLabel.text = ""
        
        LoginOrRegister.alpha = 0
        SignInButton.alpha = 0
        Username.alpha = 0
        Password.alpha = 0
        ResetButtonOutlet.alpha = 0
    
    
    }

    @IBOutlet weak var inloggbild: NSLayoutConstraint!

    func HandleRegister() {
        
        guard let email = Username.text, let password = Password.text else {
            print("Form is not valid")
            ErrorLabel.text = "Form is not valid"
            
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
            print(error)
            self.ErrorLabel.text = "Invalid email or a user with this email already exists"
            return
        }
            guard let uid = user?.uid else {
                return
            }
           
            user?.sendEmailVerification(completion: { (error:Error?) in
                if error != nil {
          
                } else {
                 self.ErrorLabel.text = "Verification sent to email"
                    print(error)
                }
            })
            
            let ref = FIRDatabase.database().reference(fromURL: "https://mathhack-7451e.firebaseio.com/")
       
            let usersReference = ref.child("users").child(uid)
            let values = ["email": email]
            
        
            ref.child("users").child(uid).updateChildValues(["highscore": 0])
            ref.child("users").child(uid).updateChildValues(["neghighscore": 0])
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err)
                    return
                }
                
              self.dismiss(animated: true, completion: nil)
                
                
            })
        }
    
    }
    
 
    func HandleLogin() {
        
            
        
      
        guard let email = Username.text, let password = Password.text else {
            print("Form is not valid")
         
            return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                self.ErrorLabel.text = "Password/Username is invalid"
                return
            }
        if (FIRAuth.auth()?.currentUser?.isEmailVerified)!{
               
            
            let credentials = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            
            UserDefaults.standard.set(self.Username.text, forKey: "Username")
            UserDefaults.standard.set(self.Password.text, forKey: "Password")
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
           self.performSegue(withIdentifier: "LoginSuccess", sender: Any?.self)
            print("logged in")
            }
            else
            {
                self.ErrorLabel.text = "You need to verify your account"
                return
            }
        })
    }
  
    @IBAction func SegmentedOptionChanged(_ sender: AnyObject) {
        
        isSignIn = !isSignIn
      
        if isSignIn == false{
            
             PasswordRepeat.isUserInteractionEnabled = true
            SignInButton.setTitle("Register", for: .normal)
           
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                
           
                self.PasswordRepeat.alpha = 1
                self.HEIGHTPIC.constant = 100
            
                self.view.layoutIfNeeded()
                })
        
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.signInVertical.constant = 80
                    self.view.layoutIfNeeded()
                })
                
          
            
        } else if isSignIn == true {
            
             PasswordRepeat.isUserInteractionEnabled = false
            SignInButton.setTitle("Sign In", for: .normal)
       
                
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                
                self.PasswordRepeat.alpha = 0
                self.HEIGHTPIC.constant = 0
                
                self.view.layoutIfNeeded()
            })
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.signInVertical.constant = 8
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let alreadySignedIn = FIRAuth.auth()?.currentUser {
            self.performSegue(withIdentifier: "LoginSuccess", sender: Any?.self)
        } else {
            // sign in
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
        UIView.animate(withDuration: 1, animations: {
            
        }) { (true) in
            self .funcShowAlphaObject()
            
        }
    }
    
    func funcShowAlphaObject() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.LoginOrRegister.alpha = 1
            
            
            }, completion: { (true) in
                
                self.showTextfields()
               
        })
        
    }

    func showTextfields(){
        
        UIView.animate(withDuration: 1, animations: {
            self.Password.alpha = 1
            self.Username.alpha = 1
            self.ResetButtonOutlet.alpha = 1
            
            
            
        }) {(true) in
            
            self.button()
        }
    }
    func button(){
        
        UIView.animate(withDuration: 1, animations: {
            
            self.SignInButton.alpha = 1
            
        }) {(true) in
            
            
        }
    }
    @IBAction func SignInRegisterPressed(_ sender: AnyObject) {
       
    if SignInButton.titleLabel?.text == "Register"{
        
        if PasswordRepeat.text == Password.text{
        HandleRegister()
        
        isSignIn = false
       
        } else {
            
       ErrorLabel.text =  "Passwords do not match"
            
        }
        
    } else if SignInButton.titleLabel?.text == "Sign In"{
        
            HandleLogin()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LoginSuccess"{
            
            let destination = segue.destination as! ViewController
            
        
        
        }
        
    }
    
    
}
