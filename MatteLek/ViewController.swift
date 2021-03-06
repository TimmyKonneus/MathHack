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
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    
     //var sound = Bool(true)
    
    @IBOutlet weak var Level: UILabel!
    
    @IBOutlet weak var Tal: UILabel!
    
    @IBOutlet weak var SvarInput: UITextField!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var RättaKnapp: UIButton!
    
    @IBOutlet weak var PoängRäknare: UILabel!
    @IBOutlet weak var FörsökRäknare: UILabel!
    @IBOutlet weak var LevelRäknare: UILabel!
    
    @IBOutlet weak var QlueLabel: UILabel!
    @IBOutlet weak var QlueButton: UIButton!
    
    @IBOutlet weak var NSTIMER: UILabel!
    @IBOutlet weak var liv3: UIImageView!
    @IBOutlet weak var liv2: UIImageView!
    @IBOutlet weak var liv1: UIImageView!
    @IBOutlet weak var pointslabel: UIImageView!
    
    var Standard = Bool()
    var Easy = Bool()
    var Medium = Bool()
    var Hard = Bool()
    var sound = Bool()
    
    var Div = Bool()
    var Mul = Bool()
    var Add = Bool()
    var Sub = Bool()
    
    @IBAction func INFOVIEW(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "INFOVIEW", sender: Any?.self)
    }
    var EasyX = Int(arc4random_uniform(UInt32(10)) + 1)
    var EasyY = Int(arc4random_uniform(UInt32(10)) + 1)
    
    var MediumX = Int(arc4random_uniform(UInt32(50)) + 1)
    var MediumY = Int(arc4random_uniform(UInt32(50)) + 1)
    
    var HardX = Int(arc4random_uniform(UInt32(200)) + 1)
    var HardY = Int(arc4random_uniform(UInt32(200)) + 1)
 
    
    
    @IBAction func Numbers(_ sender: UIButton) {
        
        sender.backgroundColor?.withAlphaComponent(0.1)
        SvarInput.text = SvarInput.text! + String(sender.tag-1)
       
        if sound == true {
        audioPlayer.currentTime = 0
        audioPlayer.play()
        }
        
        sender.backgroundColor?.withAlphaComponent(0.7)
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
    var audioPlayer2 = AVAudioPlayer()
    var audioPlayer3 = AVAudioPlayer()
    
    
    
    @IBOutlet weak var RättEllerFelMSG: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    restoreSwitchStates()
        
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = "ca-app-pub-1797867231153138/8123352001"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(request)
        
       // Levelnivå = 5
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Sample.mp3", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print(error)
        }
        
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "beep", ofType: "mp3")!))
            audioPlayer2.prepareToPlay()
        }
        catch{
            print(error)
        }
        
        do {
            audioPlayer3 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "alert", ofType: "mp3")!))
            audioPlayer3.prepareToPlay()
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
      
    }
    
    func checkIfUserIsLoggedIn() -> Bool {
     
        
         if UserDefaults.standard.bool(forKey: "annon") == false{
        if FIRAuth.auth()?.currentUser?.uid == nil   {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
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
         return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    
    func handleLogout(){
        
    do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    
         self.navigationController?.isNavigationBarHidden = true
       performSegue(withIdentifier: "BackToLogin", sender: navigationItem.leftBarButtonItem)
        
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func SkapaTal() {
        
    PoängRäknare.text = String(Poäng)
    FörsökRäknare.text = String(Försök)
        print(Add)
        print(Sub)
        print(Mul)
        print(Div)
        
    SvarInput.text = ""
     
        var y = Int()//Int(arc4random_uniform(11) + 2)

        var c = Int()//(arc4random_uniform(11) + 1)
        
        var x = Int()//(arc4random_uniform(11) + 1) +
    
        
        var z = 9
        var b = 100
        var d = 9
        
       // var q = Int(y - x)
        
    if Levelnivå >= 1 {
        
       
         y = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 2)
         c = Int(arc4random_uniform(UInt32(20)) + 1)
         x = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 10) + y
        
        if UserDefaults.standard.bool(forKey: "StandardHidden") == false {
            
             y = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 2)
             c = Int(arc4random_uniform(UInt32(20)) + 1)
             x = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 10) + y
        }
        if UserDefaults.standard.bool(forKey: "EasyHidden") == false {
            
             y = Int(arc4random_uniform(UInt32(25)) + 2)
             c = Int(arc4random_uniform(UInt32(20)) + 1)
             x = Int(arc4random_uniform(UInt32(50)) + 1) + y
        }
        if UserDefaults.standard.bool(forKey: "MediumHidden") == false {
            
            
             y = Levelnivå * Int(arc4random_uniform(UInt32(50)) + 15)
             c = Int(arc4random_uniform(UInt32(20)) + 1)
             x = Levelnivå * Int(arc4random_uniform(UInt32(100)) + 30) + y
        }
        if UserDefaults.standard.bool(forKey: "HardHidden") == false {
            
             y = Levelnivå * Int(arc4random_uniform(UInt32(125)) + 20)
             c = Int(arc4random_uniform(UInt32(20)) + 1)
             x = Levelnivå * Int(arc4random_uniform(UInt32(200)) + 50) + y
        }
        
        if UserDefaults.standard.bool(forKey: "MulOnOff") == true && UserDefaults.standard.bool(forKey: "DivOnOff") == false && UserDefaults.standard.bool(forKey: "SubOnOff") == false && UserDefaults.standard.bool(forKey: "AddOnOff") == false {
            
            x = Int(arc4random_uniform(UInt32(11)) + 1)
            y = Int(arc4random_uniform(UInt32(11)) + 1)
            
            if UserDefaults.standard.bool(forKey: "StandardHidden") && Levelnivå >= 3 {
                
                x = Int(arc4random_uniform(UInt32(15)) + 2)
                y = Int(arc4random_uniform(UInt32(12)) + 2)
            }
            
            if UserDefaults.standard.bool(forKey: "StandardHidden") && Levelnivå >= 5 {
                
                x = Int(arc4random_uniform(UInt32(20)) + 4)
                y = Int(arc4random_uniform(UInt32(15)) + 2)
            }
            
            
            if UserDefaults.standard.bool(forKey: "MediumHidden") {
                
                x = Int(arc4random_uniform(UInt32(15)) + 2)
                y = Int(arc4random_uniform(UInt32(12)) + 1)
            }
            
            if UserDefaults.standard.bool(forKey: "HardHidden") {
                
                x = Int(arc4random_uniform(UInt32(20)) + 3)
                y = Int(arc4random_uniform(UInt32(15)) + 2)
            }
            
        }
        if UserDefaults.standard.bool(forKey: "MulOnOff") == false && UserDefaults.standard.bool(forKey: "DivOnOff") == true && UserDefaults.standard.bool(forKey: "SubOnOff") == false && UserDefaults.standard.bool(forKey: "AddOnOff") == false {
            
            var modulo = x%y
            x -= modulo
        }
        
        if UserDefaults.standard.bool(forKey: "MulOnOff") == true && UserDefaults.standard.bool(forKey: "DivOnOff") == true && UserDefaults.standard.bool(forKey: "SubOnOff") == false && UserDefaults.standard.bool(forKey: "AddOnOff") == false {
            
            if Poäng % 2 == 0 {
                if UserDefaults.standard.bool(forKey: "StandardHidden") == false {
                    
                    y = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 2)
                    c = Int(arc4random_uniform(UInt32(20)) + 1)
                    x = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 10) + y
                }
                if UserDefaults.standard.bool(forKey: "EasyHidden") == false {
                    
                    y = Int(arc4random_uniform(UInt32(20)) + 2)
                    c = Int(arc4random_uniform(UInt32(10)) + 1)
                    x = Int(arc4random_uniform(UInt32(20)) + 1) + y
                }
                if UserDefaults.standard.bool(forKey: "MediumHidden") == false {
                    
                    
                    y = Levelnivå * Int(arc4random_uniform(UInt32(50)) + 15)
                    c = Int(arc4random_uniform(UInt32(20)) + 1)
                    x = Levelnivå * Int(arc4random_uniform(UInt32(100)) + 30) + y
                }
                if UserDefaults.standard.bool(forKey: "HardHidden") == false {
                    
                    y = Levelnivå * Int(arc4random_uniform(UInt32(125)) + 20)
                    c = Int(arc4random_uniform(UInt32(20)) + 1)
                    x = Levelnivå * Int(arc4random_uniform(UInt32(200)) + 50) + y
                }

                var modulo = x%y
                var YminMod = y - modulo
                x += YminMod
    
            
        }
            if Poäng % 2 == 1 {
                
                x = Int(arc4random_uniform(UInt32(11)) + 1)
                y = Int(arc4random_uniform(UInt32(11)) + 1)
                
                if UserDefaults.standard.bool(forKey: "EasyHidden") == false {
                    
                    x = Int(arc4random_uniform(UInt32(8)) + 1)
                    y = Int(arc4random_uniform(UInt32(7)) + 1)
                }
                
                if UserDefaults.standard.bool(forKey: "StandardHidden") == false && Levelnivå >= 3 {
                    
                    x = Int(arc4random_uniform(UInt32(15)) + 2)
                    y = Int(arc4random_uniform(UInt32(12)) + 2)
                }
                
                if UserDefaults.standard.bool(forKey: "StandardHidden") == false && Levelnivå >= 5 {
                    
                    x = Int(arc4random_uniform(UInt32(20)) + 4)
                    y = Int(arc4random_uniform(UInt32(15)) + 2)
                }
                
                
                if UserDefaults.standard.bool(forKey: "MediumHidden") == false {
                    
                    x = Int(arc4random_uniform(UInt32(15)) + 2)
                    y = Int(arc4random_uniform(UInt32(12)) + 1)
                }
                
                if UserDefaults.standard.bool(forKey: "HardHidden") == false {
                    
                    x = Int(arc4random_uniform(UInt32(20)) + 3)
                    y = Int(arc4random_uniform(UInt32(15)) + 2)
                }
            }
            
        }
        
        if Poäng % 3 == 0 && UserDefaults.standard.bool(forKey: "MulOnOff") == true {
            
            x = Int(arc4random_uniform(UInt32(11)) + 1)
            y = Int(arc4random_uniform(UInt32(11)) + 1)
            if UserDefaults.standard.bool(forKey: "EasyHidden") == false && Levelnivå >= 3 {
                
                x = Int(arc4random_uniform(UInt32(8)) + 1)
                y = Int(arc4random_uniform(UInt32(7)) + 1)
            }
            
            if UserDefaults.standard.bool(forKey: "StandardHidden") == false && Levelnivå >= 3 {
                
                x = Int(arc4random_uniform(UInt32(15)) + 2)
                y = Int(arc4random_uniform(UInt32(12)) + 2)
            }
            
            if UserDefaults.standard.bool(forKey: "StandardHidden") == false && Levelnivå >= 5 {
                
                x = Int(arc4random_uniform(UInt32(20)) + 4)
                y = Int(arc4random_uniform(UInt32(15)) + 2)
            }
            
            
            if UserDefaults.standard.bool(forKey: "MediumHidden") == false {
                
                x = Int(arc4random_uniform(UInt32(15)) + 2)
                y = Int(arc4random_uniform(UInt32(12)) + 1)
            }
            
            if UserDefaults.standard.bool(forKey: "HardHidden") == false {
                
                x = Int(arc4random_uniform(UInt32(20)) + 3)
                y = Int(arc4random_uniform(UInt32(15)) + 2)
            }
        }
        
        
        if Poäng % 4 == 0 && UserDefaults.standard.bool(forKey: "DivOnOff") == true {
            
            if UserDefaults.standard.bool(forKey: "StandardHidden") == false {
                
                y = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 2)
                c = Int(arc4random_uniform(UInt32(20)) + 1)
                x = Levelnivå * Int(arc4random_uniform(UInt32(z)) + 10) + y
            }
            if UserDefaults.standard.bool(forKey: "EasyHidden") == false {
                
                y = Int(arc4random_uniform(UInt32(25)) + 2)
                c = Int(arc4random_uniform(UInt32(10)) + 1)
                x = Int(arc4random_uniform(UInt32(50)) + 1) + y
            }
            if UserDefaults.standard.bool(forKey: "MediumHidden") == false {
                
                
                y = Levelnivå * Int(arc4random_uniform(UInt32(10)) + 10)
                c = Int(arc4random_uniform(UInt32(20)) + 1)
                x = Levelnivå * Int(arc4random_uniform(UInt32(100)) + 30) + y
            }
            if UserDefaults.standard.bool(forKey: "HardHidden") == false {
                
                y = Levelnivå * Int(arc4random_uniform(UInt32(20)) + 10)
                c = Int(arc4random_uniform(UInt32(20)) + 1)
                x = Levelnivå * Int(arc4random_uniform(UInt32(200)) + 50) + y
            }
            
            var modulo = x%y
            var YminMod = y - modulo
            x += YminMod
           
        }
        
        }
        
    var operatorArray = ["+", "+", "-", "-"]
    var operatorArray2 = ["*", "+", "-","-"]
    
        if UserDefaults.standard.bool(forKey: "SubOnOff") == true && UserDefaults.standard.bool(forKey: "AddOnOff") == false {
            
             operatorArray = ["-", "-", "-", "-"]
        }
        
        if UserDefaults.standard.bool(forKey: "SubOnOff") == false && UserDefaults.standard.bool(forKey: "AddOnOff") == true {
            
           operatorArray = ["+", "+", "+", "+"]
            
        }
    
    let randomIndex = Int(arc4random_uniform(UInt32(operatorArray.count)))
    let randomIndex2 = Int(arc4random_uniform(UInt32(operatorArray2.count)))
        
    var RandomOperator = operatorArray[randomIndex]
    var RandomOperator2 = operatorArray[randomIndex2]
        

        let modulo = x % y
        let modulo2 = y % c
       
        if x <= 11 && y <= 11 && Mul == true {
            
        RandomOperator = "*"
            
        }
        
        if x <= 9 && y <= 8 && Mul == true && UserDefaults.standard.bool(forKey: "EasyHidden") == false{
            
            RandomOperator = "*"
            
        }
        
        if x <= 17 && y <= 14 && Mul == true && UserDefaults.standard.bool(forKey: "StandardHidden") == false && Levelnivå >= 3{
            
            RandomOperator = "*"
            
        }
        
        if x <= 24 && y <= 17 && Mul == true && UserDefaults.standard.bool(forKey: "StandardHidden") == false && Levelnivå >= 5{
            
            RandomOperator = "*"
            
        }
        
        if x <= 17 && y <= 13 && Mul == true && UserDefaults.standard.bool(forKey: "MediumHidden") == false{
            
            RandomOperator = "*"
            
        }
        
        if x <= 23 && y <= 17 && Mul == true && UserDefaults.standard.bool(forKey: "HardHidden") == false{
            
            RandomOperator = "*"
            
        }
        
    if Int(modulo) == 0 && Div == true {
    
        RandomOperator = "/"
 
        reloadInputViews()
    
     
    let res = x/y
        
        QlueLabel.text = "\(y) * \(res) = \(x)"
        
     }
        

    if RandomOperator == "*" || RandomOperator2 == "*" { //&& Levelnivå > 2 {
        
        
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
            
            var ModuloX = x%10
            var ModuloY = y%10
            var ModuloC = c%10
            
            let nyttX = x - ((x)%10)
            let nyttY = y + ((x)%10)
            
            let newX = x - ModuloX
            let newY = y - ModuloY
            let newC = c - ModuloC
            
            let XPlusY = x+y
            let XMinusY = x-y
            let XmultY = x*y
            
            let modulo = x % y
            let modulo2 = y % c
            
            var divRes = x/y
            var divRes2 = y/c
            
            var XmultYxModuloC = XmultY * ModuloC
            
            if c < 10 {
                
                RandomOperator2 = "*"
            }
            
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
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) + (\(String(repeating: "\(y)+", count: c-1))"
            }
            if RandomOperator == "+" && RandomOperator2 == "/" {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) + (\(divRes2) * \(c) / (\(c))"
                
                if divRes2 == 1 {
                    
                    QlueLabel.text = "(\(newX) + \(ModuloX)) + \(1)"
                }
            }
            
            //Quelabel för subtraktion kombinerat med RandomOperator2
            
            if RandomOperator == "-" && RandomOperator2 == "-" {
                
               // QlueLabel.text = "(\(newX) + \(ModuloX)) - (\(newY) + \(ModuloY)) - (\(newC) + \(ModuloC))"
                
                QlueLabel.text = "(\(newX) - \(newY) - \(newC)) - (\(ModuloX) - \(ModuloY) - \(ModuloC))"
            }
            
            if RandomOperator == "-" && RandomOperator2 == "+" {
                
                 QlueLabel.text = "(\(newX) + \(ModuloX)) - (\(newY) + \(ModuloY)) + (\(newC) + \(ModuloC))"
                
            }
            
            if RandomOperator == "-" && RandomOperator2 == "*" {
                
                if x < 10 {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) - (\(String(repeating: "\(y)+", count: c-1))))"
                }
                else
                {
                QlueLabel.text = "(\(newX) + \(ModuloX)) - (\(String(repeating: "\(y)+", count: c-1))))"

                }
            }
            
            if RandomOperator == "-" && RandomOperator2 == "/" {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) - (\(divRes2) * \(c) / \(c))"
            }
            
            //Quelabel för multiplikation kombinerat med RandomOperator2
            
            if RandomOperator == "*" && RandomOperator2 == "*" {
               
                
                QlueLabel.text = "(\(XmultY)) * \(newC) + \(XmultYxModuloC))"
            }
            
            if RandomOperator == "*" && RandomOperator2 == "-" {
                
                if x < 10 {
                
                QlueLabel.text = "(\(newX) + \(ModuloX)) * (\(String(repeating: "\(y)+", count: x-1)) - ((\(newY) + \(ModuloY)))"
                }
            }
            
            if RandomOperator == "*" && RandomOperator2 == "+" {
                
                if x < 10 {
                QlueLabel.text = "(\(newX) + \(ModuloX)) * (\(String(repeating: "\(y)+", count: x-1)) + ((\(newY) + \(ModuloY)))"
                }
                else
                {
                 QlueLabel.text = "(\(newX) * \(newY)) + (\(ModuloX) * ((\(newY) + \(ModuloY)))"
                }
            }
            
            if RandomOperator == "*" && RandomOperator2 == "/" {
                
                if x < 10 {
                QlueLabel.text = "(\(newX) + \(ModuloX)) * (\(String(repeating: "\(y)+", count: x-1)) / (\(c)))"
                }
                else
                {
                 QlueLabel.text = "(\(newX) * \(newY)) + (\(ModuloX) * \(ModuloY)) / (\(c)))"
                }
                
            }
            
            //Quelabel för division kombinerat med RandomOperator2
            
            if RandomOperator == "/" && RandomOperator2 == "/" {
                
                RandomOperator2 = "+"
            }
            
            if RandomOperator == "/" && RandomOperator2 == "-" {
                
                QlueLabel.text = "(\(divRes) * \(y) / (\(y)) - (\(newC) + \(ModuloC))"
            }
            
            if RandomOperator == "/" && RandomOperator2 == "+" {
                
                QlueLabel.text = "(\(divRes) * \(y) / (\(y)) + \(newC) + \(ModuloC))"
                
            }
            
            if RandomOperator == "/" && RandomOperator2 == "*" {
                
                QlueLabel.text = "(\(divRes) * \(y) / (\(y)) * \(c)"
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

        
    RättSvar = Int(result)
        
    
    print(result)
        
        }
            
            return
        }
    }

 
    @IBAction func refreshtal(_ sender: AnyObject) {
        
        SkapaTal()
    }
    
    var counter7 = 60
    var timer = Timer()
    

    
    func timerAction() {
        counter7 -= 1
        NSTIMER.text = "\(counter7)"
        
        let counterDiv2 = counter7 / 2
        
    if NSTIMER.text == "\(0)" {
            gameover()
        }
        
        if counterDiv2%2 == 1 {
            
            NSTIMER.textColor = UIColor.black
        }
        
        if counterDiv2%2 == 0 {
            
            NSTIMER.textColor = UIColor.red
        }
        
        if counter7 == 10 {
            
            NSTIMER.textColor = UIColor.blue
        }
        if counter7 == 9 {
            
            NSTIMER.textColor = UIColor.brown
        }
        if counter7 == 8 {
            
            NSTIMER.textColor = UIColor.green
        }
        if counter7 == 7 {
            
            NSTIMER.textColor = UIColor.purple
        }
        if counter7 == 6 {
            
            NSTIMER.textColor = UIColor.brown
        }
        if counter7 == 5 {
            
            NSTIMER.textColor = UIColor.yellow
        }
        if counter7 == 4 {
            
            NSTIMER.textColor = UIColor.white
        }
        if counter7 == 3 {
            
            NSTIMER.textColor = UIColor.darkGray
        }
        if counter7 == 2 {
            
            NSTIMER.textColor = UIColor.red
        }
        if counter7 == 1 {
            
            NSTIMER.textColor = UIColor.orange
        }
        
    }
   

    @IBAction func RättaKnapp_press(_ sender: AnyObject) {

        if RättaKnapp.titleLabel?.text == "Start"{
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
            RättaKnapp.isUserInteractionEnabled = true
            Poäng = 0
            Försök = 3
            FörsökRäknare.text = String(3)
          //  RättEllerFelMSG.text = ""
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
            Poäng += 1
            LevelPoäng += 1
            QlueLabel.isHidden = true
            counter7 = 60
            
            if sound == true{
                    //audioPlayer2.currentTime = 0
                    audioPlayer2.play()
                }
            
                
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
            
       //     RättEllerFelMSG.text = "FEL"
     //       RättEllerFelMSG.textColor = UIColor.red
            SvarInput.text = ""
            Försök = Försök - 1
            if sound == true {
                audioPlayer3.currentTime = 0
                audioPlayer3.play()
            }
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
        
        //RättEllerFelMSG.text = "GAME OVER"
        RättaKnapp.setTitle("Start", for: .normal)
        Tal.text = ""
        SvarInput.isUserInteractionEnabled = false
        
        timer.invalidate()
        counter7 = 60
        
        liv1.isHidden = false
        liv2.isHidden = false
        liv3.isHidden = false
        
        if UserDefaults.standard.bool(forKey: "annon") == false {
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
        }
        ShowScoreBoard()
    }
    
    @IBAction func QlueButtonPressed(_ sender: UIButton) {
        
    }
    var GameSettingsVC = GameSettingsViewController()
    
    @IBAction func SettingsPressed(_ sender: AnyObject) {
        
        if RättaKnapp.titleLabel?.text != "Check"{
         HandleMore()
    }
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
    
    func saveSwitchStates() {
        
        UserDefaults.standard.set(Easy, forKey: "EasyHidden")
        UserDefaults.standard.set(Standard, forKey: "StandardHidden")
        UserDefaults.standard.set(Medium, forKey: "MediumHidden")
        UserDefaults.standard.set(Hard, forKey: "HardHidden")
        
        UserDefaults.standard.set(Add, forKey: "AddOnOff")
        UserDefaults.standard.set(Sub, forKey: "SubOnOff")
        UserDefaults.standard.set(Mul, forKey: "MulOnOff")
        UserDefaults.standard.set(Div, forKey: "DivOnOff")
        
        UserDefaults.standard.set(sound, forKey: "SoundOnOff")
        
        UserDefaults.standard.synchronize()
        
    }
    
    func restoreSwitchStates() {
        
        Easy = UserDefaults.standard.bool(forKey: "EasyHidden")
        Standard = UserDefaults.standard.bool(forKey: "StandardHidden")
        Medium = UserDefaults.standard.bool(forKey: "MediumHidden")
        Hard = UserDefaults.standard.bool(forKey: "HardHidden")
        
        Add = UserDefaults.standard.bool(forKey: "AddOnOff")
        Sub = UserDefaults.standard.bool(forKey: "SubOnOff")
        Mul = UserDefaults.standard.bool(forKey: "MulOnOff")
        Div = UserDefaults.standard.bool(forKey: "DivOnOff")
        
        sound = UserDefaults.standard.bool(forKey: "SoundOnOff")
        
        UserDefaults.standard.synchronize()
    }
}

