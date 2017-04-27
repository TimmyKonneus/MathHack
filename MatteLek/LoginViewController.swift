//
//  LoginViewController.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 16/04/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit



class LoginViewController: UIViewController {
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!

    @IBOutlet weak var LoginOrRegister: UISegmentedControl!
    
    @IBOutlet weak var SignInButton: BounceButton!
    
    var isSignIn:Bool = true
    var int = Int()
    var GlobalUID = String()
    var Data = String()
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        ErrorLabel.text = ""
       
      /*  let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
*/
        
        LoginOrRegister.alpha = 0
        SignInButton.alpha = 0
        Username.alpha = 0
        Password.alpha = 0
    }
    
  /*  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out from fb")
    }
  

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
            
        }
        
        showEmailwithFb()
        
        
        print("login in fb!")
        self.performSegue(withIdentifier: "LoginSuccess", sender: Any?.self)
        print("logged in")
        
    }
    
    func showEmailwithFb(){
        
        let accessToken = FBSDKAccessToken.current()
        
        //guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in

            
            
            if error != nil {
               
                print(error)
                return
            }
            
            print("Succesfully logged in with user:", user)
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                if err != nil {
                    
                    
                    print("failed to start graph")
                    return
                }
                
                
                print(result)
            }
         
        })
        
    
    }*/
    
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
           
            let ref = FIRDatabase.database().reference(fromURL: "https://mathhack-7451e.firebaseio.com/")
       
            let usersReference = ref.child("users").child(uid)
            let values = ["email": email]
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
            
            
            let credentials = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            
            if error != nil {
                print(error)
               self.ErrorLabel.text = "Password/Username is invalid"
                return
            }
            
           self.performSegue(withIdentifier: "LoginSuccess", sender: Any?.self)
            print("logged in")
        })
        
    }
    
 

    @IBAction func SegmentedOptionChanged(_ sender: AnyObject) {
        
        isSignIn = !isSignIn
        
        if isSignIn == false{
            
            SignInButton.setTitle("Register", for: .normal)
        } else if isSignIn == true {
            
            SignInButton.setTitle("Sign In", for: .normal)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        HandleRegister()
        
        
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
