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
import AVFoundation

class ViewController: UIViewController {
    
     //var sound = Bool(true)
    
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
    
    var EasyX = Int(arc4random_uniform(UInt32(10)) + 1)
    var EasyY = Int(arc4random_uniform(UInt32(10)) + 1)
    
    var MediumX = Int(arc4random_uniform(UInt32(50)) + 1)
    var MediumY = Int(arc4random_uniform(UInt32(50)) + 1)
    
    var HardX = Int(arc4random_uniform(UInt32(200)) + 1)
    var HardY = Int(arc4random_uniform(UInt32(200)) + 1)
    
    
    
    @IBAction func Numbers(_ sender: UIButton) {
        
        SvarInput.text = SvarInput.text! + String(sender.tag-1)
       
        if sound == true {
        audioPlayer.currentTime = 0
        audioPlayer.play()
        }
    }
    
    @IBAction func clearInput(_ sender: AnyObject) {
        
        SvarInput.text = ""
        
        if sound == true {
        audioPlayer.currentTime = 0
        audioPlayer.play()
        }
    }
    
   
    @IBAction func MakeInputNegative(_ sender: AnyObject) {
        
        if sound == true{
        audioPlayer.currentTime = 0
        audioPlayer.play()
        }
        var minus = "-"
        
        if SvarInput.text?.hasPrefix(minus) == false {
        var minus = "-"
        SvarInput.text = String(minus + SvarInput.text!)

            
        } else if SvarInput.text?.hasPrefix(minus) == true {
     
     SvarInput.text?.remove(at: (SvarInput.text?.startIndex)!)
          
            
        } else if SvarInput.text?.hasPrefix(minus) == true {
            SvarInput.text = "-"
            
        }
       

    }
    var Poäng = Int()
    var Försök = Int(3)
    var RättSvar = Int()
    var Levelnivå = Int(1)
    var LevelPoäng = Int()
    var Qlue = String()
    
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    
    var audioPlayer = AVAudioPlayer()
    

    
    @IBOutlet weak var RättEllerFelMSG: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Sample.mp3", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print(error)
        }
        
        
        self.navigationController?.isNavigationBarHidden = false
        
        RättaKnapp.setTitle("Start", for: .normal)
       
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
      
        if RättaKnapp.titleLabel?.text == "Start" {

            SvarInput.isUserInteractionEnabled = false
            
            
        }
        print(Bool(sound))
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
    
    func SkapaTal() {
        
    PoängRäknare.text = String(Poäng)
    FörsökRäknare.text = String(Försök)
        
    SvarInput.text = ""
     
        var y = Int(arc4random_uniform(11) + 2)

        var c = Int(arc4random_uniform(11) + 1)
        
        var x = Int(arc4random_uniform(11) + 1) + y
        
        var z = 9
        var b = 100
        var d = 9
        
       // var q = Int(y - x)
        
    if Levelnivå > 1 {
        
        x = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 10) + y
        y = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 2)
        c = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 1)
        
        }
    
    var operatorArray = ["+", "+", "+", "+"] 
    let operatorArray2 = ["*", "*", "/","/"]
    
    let randomIndex = Int(arc4random_uniform(UInt32(operatorArray.count)))
    let randomIndex2 = Int(arc4random_uniform(UInt32(operatorArray2.count)))
        
    var RandomOperator = operatorArray[randomIndex]
    var RandomOperator2 = operatorArray[randomIndex2]
        
        let modulo = x % y
        let modulo2 = y % c
       
        if x < 11 && y < 11 {
            
        RandomOperator = "*"
            
        }
        
    if Int(modulo) == 0 {
    
        RandomOperator = "/"
 
        reloadInputViews()
    
     
    let res = x/y
        
        QlueLabel.text = "\(y) * \(res) = \(x)"
        
     }
        

    if RandomOperator == "*" || RandomOperator2 == "*"{ //&& Levelnivå > 2 {
        
        
        if RandomOperator == "*" {
            
            Qlue = String(repeating: "\(x)+", count: y-1) + "\(x)"
            QlueLabel.text = Qlue
           
        }
        
        }
        
    if RandomOperator == "+" && Levelnivå >= 1  {
        
        if x >= 1 {
    
        let AdditionModuloX = x%10
        let AdditionModuloY = y%10
        
        let nyttX = x - ((x)%10)
        let nyttY = y + ((x)%10)
           
        let newX = x - AdditionModuloX
        let newY = y - AdditionModuloY
            
        QlueLabel.text = "\(newX) + \(AdditionModuloX) + \(newY) + \(AdditionModuloY)"
            
            
            if AdditionModuloX == 0 {
                
                QlueLabel.text = "\(newX) + \(newY) + \(AdditionModuloY)"
            }
            
            if AdditionModuloY == 0 {
                
                QlueLabel.text = "\(newX) + \(AdditionModuloX) + \(newY)"
                
            }
        
            if  x%10 != 0 && y%10 != 0 {
              
                if x >= 11 {
                QlueLabel.text = "\(nyttX) + \(nyttY)"
                
                }
            }
            if x < 11 && x > 1{
                    
                     QlueLabel.text = String(repeating: "\(1)+", count: x-1) + "\(1) + \(y)"
                }
            }
        }
    
    
    if RandomOperator == "-" && Levelnivå < 5 {
        
        if y > x {
        
    let q = x-y
    let negativ_mellanskillnad = q * q
        
     x += negativ_mellanskillnad * 2
        
        }
        
        let SubModuloX = x%10
        let SubModuloY = y%10
        
        let nyttX = x - ((x)%10)
        let nyttY = y + ((x)%10)
        
        let newX = x - SubModuloX
        let newY = y - SubModuloY
        
        
        QlueLabel.text = "\(newX) + \(SubModuloX) - \(newY) + \(SubModuloY)"
        
        if SubModuloX == 0 {
            
            QlueLabel.text = "\(newX) - \(newY) + \(SubModuloY)"
        }
        
        if SubModuloY == 0 {
            
            QlueLabel.text = "\(newX) + \(SubModuloX) - \(newY)"
        
        }
        
        var modulo = x%10
        
        if y <= 9 && modulo != 0{
            
            var xminus = x - modulo
            var yplus = y + modulo
            
            Qlue = String(repeating: "\(1)-", count: y-1) + "\(1)"
            QlueLabel.text = "\(x) - \(Qlue)"
        }
        }
        
        if Levelnivå >= 5 {
            
            let ModuloX = x%10
            let ModuloY = y%10
            let ModuloC = c%10
            
            let nyttX = x - ((x)%10)
            let nyttY = y + ((x)%10)
            
            let newX = x - ModuloX
            let newY = y - ModuloY
            let newC = c - ModuloC
            
            let XPlusY = x+y
            let XMinusY = x-y
            
            let modulo = x % y
            let modulo2 = y % c
            
            var divRes = x/y
            var divRes2 = y/c
            
           if Int(modulo) == 0 {
           // RandomOperator = "/"
            }
            
           if Int(modulo2) == 0 {
            RandomOperator2 = "/"
            
            }
            
            //Quelabel för addition kombinerat med RandomOperator2
            
            if RandomOperator == "+" && RandomOperator2 == "+" {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) + (\(newY) + \(ModuloY)) + (\(newC) + \(ModuloC))"
            }
            if RandomOperator == "+" && RandomOperator2 == "-" {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) + (\(newY) + \(ModuloY)) - (\(newC) + \(ModuloC))"
            }
            if RandomOperator == "+" && RandomOperator2 == "*" {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) + ((\(newY) + \(ModuloY)) + (\(String(repeating: "\(y)+", count: c-1))))"
            }
            if RandomOperator == "+" && RandomOperator2 == "/" {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) + (\(divRes2) * \(c) / (\(c))"
                
                if divRes2 == 1 {
                    
                    QlueLabel.text = "(\(newX) + \(ModuloX)) + \(1)"
                }
            }
            
            //Quelabel för subtraktion kombinerat med RandomOperator2
            
            if RandomOperator == "-" && RandomOperator2 == "-" {
                
                
            }
            
            if RandomOperator == "-" && RandomOperator2 == "+" {
                
                
            }
            
            if RandomOperator == "-" && RandomOperator2 == "*" {
                
                
            }
            
            if RandomOperator == "-" && RandomOperator2 == "/" {
                
                
            }
            
            //Quelabel för multiplikation kombinerat med RandomOperator2
            
            if RandomOperator == "*" && RandomOperator2 == "*" {
                
                
            }
            
            if RandomOperator == "*" && RandomOperator2 == "-" {
                
                
            }
            
            if RandomOperator == "*" && RandomOperator2 == "+" {
                
                
            }
            
            if RandomOperator == "*" && RandomOperator2 == "/" {
                
                
            }
            
            //Quelabel för division kombinerat med RandomOperator2
            
            if RandomOperator == "/" && RandomOperator2 == "/" {
                
                
            }
            
            if RandomOperator == "/" && RandomOperator2 == "-" {
                
                
            }
            
            if RandomOperator == "/" && RandomOperator2 == "+" {
                
                
            }
            
            if RandomOperator == "/" && RandomOperator2 == "*" {
                
                
            }
            
        }
        
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
        
       /* if RandomOperator2 == "/" {
             let operatorArray = ["*", "-", "+","+"]
             let RandomOperator = operatorArray[randomIndex]
            
        }
        
        if RandomOperator == "/" {
            let operatorArray = ["*", "-", "+","+"]
            let RandomOperator2 = operatorArray[randomIndex]
            
        }*/
        
      /* if RandomOperator == "/" || RandomOperator2 == "/" {
            
          y = Int(arc4random_uniform(9) + 1)
            
          c = Int(arc4random_uniform(9) + 1)
            
          //  if RandomOperator == "/" {
            
            }
            
            if x > y {
                
                x -= x%y
                
            }*/
            
         /*   if RandomOperator2 == "/" {
                
                
            }
            
            if y > c {
            
                y -= y%c
                
            }
        }*/
        
    RättSvar = Int(result)
        
    
    print(result)
        
        }
            
            return
        }
    }

 
    @IBAction func refreshtal(_ sender: AnyObject) {
        
        SkapaTal()
    }
    

    @IBAction func RättaKnapp_press(_ sender: AnyObject) {
        
        if RättaKnapp.titleLabel?.text == "Start"{
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
            
        }
        
        LevelRäknare.text = String(Levelnivå)
        RättaKnapp.setTitle("Check", for: .normal)
        SvarInput.isUserInteractionEnabled = true
    
        if RättSvar == Int(SvarInput.text!) || RättaKnapp.titleLabel?.text == "Start" {
            
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
            
            } else if RättaKnapp.titleLabel?.text == "Start" {
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
        RättaKnapp.setTitle("Start", for: .normal)
        Tal.text = ""
        SvarInput.isUserInteractionEnabled = false
        
        liv1.isHidden = false
        liv2.isHidden = false
        liv3.isHidden = false
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(uid!).observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
       
            let highscore = value?["highscore"] as? Int
            let neghighscore = value?["neghighscore"] as? Int
            
   
            
            if highscore != nil{
            self.globalHS = highscore!
            }
        })
        var highscorepoints = Poäng
         if globalHS < highscorepoints || globalHS == nil {
        var ref = FIRDatabase.database().reference(fromURL: "https://mathhack-7451e.firebaseio.com/")
        var usersReference = ref.child("users").child(uid!)
        let values = ["highscore": highscorepoints, "neghighscore": -highscorepoints]
        
        
    
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err)
                return
            }
            
            print("score updated")
            self.globalHS = highscorepoints
            self.globalHSNEG = -highscorepoints
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
    
 
    
    
    @IBAction func QluebuttonIsPressed(_ sender: AnyObject) {
        
        if QlueLabel.isHidden == true{
            
            QlueLabel.isHidden = false
            
        } else if QlueLabel.isHidden == false{
            
            QlueLabel.isHidden = true
        }
    }
      var globalHS = Int()
        var globalHSNEG = Int()
        var sound = Bool(true)
    
    var OnOff = String()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sound == true {
            
            OnOff = "1"
        }
        else
        {
            OnOff = "2"
        }
        
        if segue.identifier == "ScoreView" {
            
            let destination = segue.destination as! ScoreboardView

            destination.RetrievedScore = Poäng
            
            if segue.identifier == "GameSettings"{
                
                let destination = segue.destination as! GameSettingsViewController
            
               if sound == true {
                 
             destination.OnOff = (true as? Bool)!
            //destination.SoundSwitch.setOn(true, animated: true)
    
            
                }
                else if sound == false
                {
                 
                   destination.OnOff = (false as? Bool)!
                  //  destination.SoundSwitch.setOn(false, animated: false)
                }
                
            //destination.OnOff = Bool(sound)
           // destination.hej = "1"
            
        }
    }
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
}

