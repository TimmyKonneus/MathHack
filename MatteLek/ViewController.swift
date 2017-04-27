//
//  ViewController.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 30/03/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class ViewController: UIViewController {

    @IBOutlet weak var Level: UILabel!
    
    @IBOutlet weak var Tal: UILabel!
    
    @IBOutlet weak var SvarInput: UITextField!
    
    @IBOutlet weak var RättaKnapp: UIButton!
    
    @IBOutlet weak var PoängRäknare: UILabel!
    @IBOutlet weak var FörsökRäknare: UILabel!
    @IBOutlet weak var LevelRäknare: UILabel!
    
    @IBOutlet weak var QlueLabel: UILabel!
    @IBOutlet weak var QlueButton: UIButton!
    
    @IBOutlet weak var liv3: UIImageView!
    @IBOutlet weak var liv2: UIImageView!
    @IBOutlet weak var liv1: UIImageView!
    @IBOutlet weak var pointslabel: UIImageView!
    
    var Poäng = Int()
    var Försök = Int(3)
    var RättSvar = Int()
    var Levelnivå = Int(1)
    var LevelPoäng = Int()
    var Qlue = String()
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    
    @IBOutlet weak var RättEllerFelMSG: UILabel!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.navigationController?.isNavigationBarHidden = false
        RättaKnapp.setTitle("Starta", for: .normal)
       
        ref = FIRDatabase.database().reference()
        refHandle = ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let data = snapshot.value as! [String: AnyObject]
   
        })
        
        checkIfUserIsLoggedIn()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        
      
        
        FörsökRäknare.isHidden = true
        QlueLabel.isHidden = true
        
        PoängRäknare.text = String(Poäng)
        FörsökRäknare.text = String(Försök)
        Level.text = String(Levelnivå)
        
        RättaKnapp.layer.cornerRadius = 12
      
        
        if RättaKnapp.titleLabel?.text == "Starta" {

            SvarInput.isUserInteractionEnabled = false
            
        }
      
    }
    
    func checkIfUserIsLoggedIn() {
     
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else{
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    self.navigationItem.title = dictionary["email"] as? String
                    print(snapshot)
                }
                print(snapshot)
                
            })
        }
      
        
    }
    
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    
         self.navigationController?.isNavigationBarHidden = true
       performSegue(withIdentifier: "BackToLogin", sender: navigationItem.leftBarButtonItem)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        }
    
    
    func SkapaTal() {
        
    PoängRäknare.text = String(Poäng)
    FörsökRäknare.text = String(Försök)
        
    SvarInput.text = ""
        
        var x = Int(arc4random_uniform(10) + 1)
        
        var y = Int(arc4random_uniform(11) + 1)

        var c = Int(arc4random_uniform(11) + 1)
        
        var z = 9
        
        var q = Int(y - x)
        
    if Levelnivå > 1 {
        
        x = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 1)
        y = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 1)
        c = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 1)
        
        }
    
    let operatorArray = ["*", "-", "+"]
    let operatorArray2 = ["+", "*", "-"]
    
    let randomIndex = Int(arc4random_uniform(UInt32(operatorArray.count)))
    let randomIndex2 = Int(arc4random_uniform(UInt32(operatorArray2.count)))
        
    let RandomOperator = operatorArray[randomIndex]
    let RandomOperator2 = operatorArray[randomIndex2]

    if RandomOperator == "*" || RandomOperator2 == "*"{ //&& Levelnivå > 2 {
        
 
        x = Int(arc4random_uniform(UInt32(z)) + 1)
        y = Int(arc4random_uniform(UInt32(z)) + 1)
        c = Int(arc4random_uniform(UInt32(z)) + 1)
        
        if RandomOperator == "*" {
            
            Qlue = String(repeating: "\(x)+", count: y-1) + "\(x)"
            QlueLabel.text = Qlue
           
        }
        
        }
    
    if RandomOperator == "+" && Levelnivå >= 1  {
        
        if x >= 1 {
            
        let Summa = x + y
            
        var hej = ((Summa)%10)
    
        var skillnad = 10 - ((x)%10)
           
        var plusxskillnad = x + skillnad
        var plusyskillnad = y - skillnad
        
        var minusxskillnad = x - skillnad
        var minusyskillnad = y + skillnad
            
        QlueLabel.text = "No qlue for this easy one, I'm sure you can figure it out yourself"
        
            if  x%10 != 0 && y%10 != 0 {
           
                if skillnad == 1 || skillnad == 2 || skillnad == 3 || skillnad == 4  {
                    
                     QlueLabel.text = "\(plusxskillnad) + \(plusyskillnad)"
                    
                } else if skillnad == 5 || skillnad == 6 || skillnad == 7 || skillnad == 8 || skillnad == 9{
                
                    QlueLabel.text = "\(plusxskillnad) + \(plusyskillnad)"
       
                }
            }
        }
    }
    
    
    if RandomOperator == "-" && Levelnivå < 5 {
        
        if y > x {
        
        var negativ_mellanskillnad = q * q
        
         x += negativ_mellanskillnad * 2
        
        }
        
        QlueLabel.text = "No qlue for this easy one, I'm sure you can figure it out yourself"
        var modulo = x%10
        
        if x >= 1 && modulo != 0{
            
            var xminus = x - modulo
            var yplus = y + modulo
            
            QlueLabel.text = "\(xminus) - \(yplus)"
            
        }
            
        }
        
   // Tal.text = "\(x) \(RandomOperator) \(y)"
       
        if Levelnivå < 5 { let expression = NSExpression(format:"\(x) \(RandomOperator) \(y)")
   if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
    
     Tal.text = "\(x) \(RandomOperator) \(y)"
    RättSvar = Int(result)
    print(result)
        }

        return
        }
        
    if Levelnivå >= 5 { let expression = NSExpression(format:"\(x) \(RandomOperator) \(y) \(RandomOperator2) \(c)")
    if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
                
    Tal.text = "\(x) \(RandomOperator) \(y) \(RandomOperator2) \(c)"
    RättSvar = Int(result)
    print(result)
            }
            
            return
        }
    }

    @IBAction func RättaKnapp_press(_ sender: AnyObject) {
        
        if RättaKnapp.titleLabel?.text == "Starta"{
            RättaKnapp.isUserInteractionEnabled = true
            Poäng = 0
            Försök = 3
            FörsökRäknare.text = String(3)
            RättEllerFelMSG.text = ""
            PoängRäknare.text = String(0)
            FörsökRäknare.text = String(3)
            Levelnivå = 1
            liv1.isHidden = false
            liv2.isHidden = false
            liv3.isHidden = false
            
            
        }
        
        LevelRäknare.text = String(Levelnivå)
        RättaKnapp.setTitle("Rätta", for: .normal)
        SvarInput.isUserInteractionEnabled = true
    
        if RättSvar == Int(SvarInput.text!) || RättaKnapp.titleLabel?.text == "Starta" {
            
            if RättSvar == Int(SvarInput.text!){
            RättEllerFelMSG.text = "RÄTT"
            RättEllerFelMSG.textColor = UIColor.green
            Poäng += 1
            LevelPoäng += 1
            QlueLabel.isHidden = true
                
                    self.pointslabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .allowUserInteraction, animations: {
                        self.pointslabel.transform = CGAffineTransform.identity
                        
                    }) { (completed: Bool) in
               
                    }
          
                if LevelPoäng == 5 {
                    
                    LevelPoäng = 0
                    Levelnivå += 1
                    Level.text = String(Levelnivå)
                    
            
                }
            
            } else if RättaKnapp.titleLabel?.text == "Starta" {
                
              
            }
            
            SkapaTal()
            
        } else {
            
            RättEllerFelMSG.text = "FEL"
            RättEllerFelMSG.textColor = UIColor.red
            SvarInput.text = ""
            Försök = Försök - 1
            
            refreshFörsök()
          
            livkvar()
            
        }

        return
        
    }



    func livkvar() {
        
        if Försök == 2 {
            self.liv3.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .allowUserInteraction, animations: {
                self.liv3.transform = CGAffineTransform.identity
                
             }) { (completed: Bool) in
             self.liv3.isHidden = true
        

            //liv3.isHidden = true
            self.liv2.isHidden = false
            self.liv1.isHidden = false
            }
            
        } else if Försök == 1 {
            self.liv2.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .allowUserInteraction, animations: {
                self.liv2.transform = CGAffineTransform.identity
                
            }) { (completed: Bool) in
            
            self.liv3.isHidden = true
            self.liv2.isHidden = true
            self.liv1.isHidden = false
            }
        } else if Försök == 0{
            
            self.liv1.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .allowUserInteraction, animations: {
                self.liv1.transform = CGAffineTransform.identity
                
            }) { (completed: Bool) in

            self.liv3.isHidden = true
            self.liv2.isHidden = true
            self.liv1.isHidden = true
                
            self.gameover()
            
          
        }
    
        }
    }

    
    func refreshFörsök() {
        
        FörsökRäknare.text = String(Försök)
        
    }
    
    func retrieveHighscore() {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
       
    }
    
    func ShowScoreBoard(){
        performSegue(withIdentifier: "ScoreView", sender: Any?.self)
    }

    func gameover() {
        
        RättEllerFelMSG.text = "GAME OVER"
        RättaKnapp.setTitle("Starta", for: .normal)
        Tal.text = ""
        SvarInput.isUserInteractionEnabled = false

        
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(uid!).observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let highscore = value?["highscore"] as? Int
            if highscore != nil{
            self.globalHS = highscore!
            }
        })
        
       
        var highscorepoints = Poäng
         if globalHS < highscorepoints || globalHS == nil {
        var ref = FIRDatabase.database().reference(fromURL: "https://mathhack-7451e.firebaseio.com/")
        var usersReference = ref.child("users").child(uid!)
        let values = ["highscore": highscorepoints]
        
           
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err)
                return
            }
            
            print("score updated")
            self.globalHS = highscorepoints
          //  self.dismiss(animated: true, completion: nil)
            
            
        })
            
        }
        
        ShowScoreBoard()
        
    }
    
    @IBAction func QlueButtonPressed(_ sender: UIButton) {
        
    }
                            
    
    var GameSettingsVC = GameSettingsViewController()
    
    @IBAction func SettingsPressed(_ sender: AnyObject) {
        
         HandleMore()
        
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
        
        let launcher = SettingsLauncher()
        launcher.ViewController = self
        return launcher
    }()

    func HandleMore(){
 
        settingsLauncher.showSettings()
    }
    
    func showControllersForSetting(setting: Setting){
        
            if setting.name == "Change difficulty"{
         performSegue(withIdentifier: "ChangeDifficulty", sender: Any?.self)
        }
        
        if setting.name == "Game Settings"{
            performSegue(withIdentifier: "GameSettings", sender: Any?.self)
        }
        
        if setting.name == "Scoreboard"{
            performSegue(withIdentifier: "Scoreboard", sender: Any?.self)
        }

    }
    
    @IBAction func QluebuttonIsPressed(_ sender: AnyObject) {
        
        if QlueLabel.isHidden == true{
            
            QlueLabel.isHidden = false
            
        } else if QlueLabel.isHidden == false{
            
            QlueLabel.isHidden = true
        }
    }
    
      var globalHS = Int()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScoreView" {
            
            let destination = segue.destination as! ScoreboardView

            destination.RetrievedScore = Poäng
         
         
        }
    }

    
    

}

