//
//  GameSettingsViewController.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 15/04/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit

class GameSettingsViewController: UIViewController {
    
    @IBOutlet weak var SoundSwitch: UISwitch!
    
    @IBOutlet weak var Standard: UIImageView!
    @IBOutlet weak var Easy: UIImageView!
    @IBOutlet weak var Medium: UIImageView!
    @IBOutlet weak var Hard: UIImageView!

    @IBOutlet weak var Add: UISwitch!
    @IBOutlet weak var Sub: UISwitch!
    @IBOutlet weak var Mul: UISwitch!
    @IBOutlet weak var Div: UISwitch!
    
    
    var OnOff = Bool()

    @IBAction func OnOff(_ sender: AnyObject) {
       if (sender.isOn) == true {
        UserDefaults.standard.set(Bool(true), forKey: "SoundOnOff")
     
        }else{
        if (sender.isOn) == false {
        UserDefaults.standard.set(Bool(false), forKey: "SoundOnOff")
            }
        }
    }
    @IBAction func AddOnOff(_ sender: AnyObject) {
        if (sender.isOn) == true {
            UserDefaults.standard.set(Add.isOn, forKey: "AddOnOff")
            UserDefaults.standard.synchronize()
        }else{
            if (sender.isOn) == false {
                UserDefaults.standard.set(Add.isOn, forKey: "AddOnOff")
                UserDefaults.standard.synchronize()
            }
    }
    }
    @IBAction func SubOnOff(_ sender: AnyObject) {
        if (sender.isOn) == true {
            UserDefaults.standard.set(Bool(true), forKey: "SubOnOff")
            UserDefaults.standard.synchronize()
        }else{
            if (sender.isOn) == false {
                UserDefaults.standard.set(Bool(false), forKey: "SubOnOff")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    @IBAction func MulOnOff(_ sender: AnyObject) {
        if (sender.isOn) == true {
            UserDefaults.standard.set(Bool(true), forKey: "MulOnOff")
            UserDefaults.standard.synchronize()
        }else{
            if (sender.isOn) == false {
                UserDefaults.standard.set(Bool(false), forKey: "MulOnOff")
                 UserDefaults.standard.synchronize()
            }
        }
    }
    @IBAction func DivOnOff(_ sender: AnyObject) {
        if (sender.isOn) == true {
            UserDefaults.standard.set(Bool(true), forKey: "DivOnOff")
            UserDefaults.standard.synchronize()
        }else{
            if (sender.isOn) == false {
                UserDefaults.standard.set(Bool(false), forKey: "DivOnOff")
                UserDefaults.standard.synchronize()
            }
        }
    }

    var EasyX = Int(arc4random_uniform(UInt32(10)) + 1)
    var EasyY = Int(arc4random_uniform(UInt32(10)) + 1)
    
    var MediumX = Int(arc4random_uniform(UInt32(50)) + 1)
    var MediumY = Int(arc4random_uniform(UInt32(50)) + 1)
    
    var HardX = Int(arc4random_uniform(UInt32(200)) + 1)
    var HardY = Int(arc4random_uniform(UInt32(200)) + 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restoreSwitchStates()

       print(OnOff)
    }

    func saveSwitchStates() {
        
        UserDefaults.standard.set(Add.isOn, forKey: "AddOnOff")
        UserDefaults.standard.set(SoundSwitch, forKey: "SoundOnOff")
        UserDefaults.standard.set(Sub.isOn, forKey: "SubOnOff")
        UserDefaults.standard.set(Mul.isOn, forKey: "MulOnOff")
        UserDefaults.standard.set(Div.isOn, forKey: "DivOnOff")
        
        UserDefaults.standard.set(StandardImage.isHidden, forKey: "StandardHidden")
        UserDefaults.standard.set(EeasyImage.isHidden, forKey: "EasyHidden")
        UserDefaults.standard.set(MediumImage.isHidden, forKey: "MediumHidden")
        UserDefaults.standard.set(HardImage.isHidden, forKey: "HardHidden")
     
        UserDefaults.standard.synchronize()
        
    }
    
    func restoreSwitchStates() {
        Add.isOn = UserDefaults.standard.bool(forKey: "AddOnOff")
        SoundSwitch.isOn = UserDefaults.standard.bool(forKey: "SoundOnOff")
        Sub.isOn = UserDefaults.standard.bool(forKey: "SubOnOff")
        Mul.isOn = UserDefaults.standard.bool(forKey: "MulOnOff")
        Div.isOn = UserDefaults.standard.bool(forKey: "DivOnOff")
        
        StandardImage.isHidden = UserDefaults.standard.bool(forKey: "StandardHidden")
        EeasyImage.isHidden = UserDefaults.standard.bool(forKey: "EasyHidden")
        MediumImage.isHidden = UserDefaults.standard.bool(forKey: "MediumHidden")
        HardImage.isHidden = UserDefaults.standard.bool(forKey: "HardHidden")
   
        UserDefaults.standard.synchronize()
    }
    
    @IBOutlet weak var StandardOutlet: UIButton!
    @IBOutlet weak var easyOutlet: UIButton!
    @IBOutlet weak var MediumOutlet: UIButton!
    @IBOutlet weak var HardOutlet: UIButton!
    
    @IBOutlet weak var StandardImage: UIImageView!
    
    @IBOutlet weak var EeasyImage: UIImageView!
    
    @IBOutlet weak var MediumImage: UIImageView!
    
    @IBOutlet weak var HardImage: UIImageView!
    
    @IBAction func Standard(_ sender: AnyObject) {
        
    StandardImage.isHidden = false
    EeasyImage.isHidden = true
    MediumImage.isHidden = true
    HardImage.isHidden = true
        
        if (StandardImage.isHidden) == true {
            UserDefaults.standard.set(Bool(false), forKey: "StandardHidden")
            UserDefaults.standard.synchronize()
        }else{
            if (StandardImage.isHidden) == false {
             
                 UserDefaults.standard.set(Bool(true), forKey: "EasyHidden")
                 UserDefaults.standard.set(Bool(false), forKey: "StandardHidden")
                UserDefaults.standard.set(Bool(true), forKey: "MediumHidden")
                UserDefaults.standard.set(Bool(true), forKey: "HardHidden")
                
                UserDefaults.standard.synchronize()
            }
        }
    }
 
    @IBAction func easy(_ sender: AnyObject) {
        
        StandardImage.isHidden = true
        EeasyImage.isHidden = false
        MediumImage.isHidden = true
        HardImage.isHidden = true
        
        if (EeasyImage.isHidden) == true {
            UserDefaults.standard.set(Bool(false), forKey: "EasyHidden")
            UserDefaults.standard.synchronize()
        }else{
            if (EeasyImage.isHidden) == false {
                
                 UserDefaults.standard.set(Bool(false), forKey: "EasyHidden")
                UserDefaults.standard.set(Bool(true), forKey: "StandardHidden")
                 UserDefaults.standard.set(Bool(true), forKey: "MediumHidden")
                 UserDefaults.standard.set(Bool(true), forKey: "HardHidden")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    @IBAction func medium(_ sender: AnyObject) {
        
        StandardImage.isHidden = true
        EeasyImage.isHidden = true
        MediumImage.isHidden = false
        HardImage.isHidden = true
        
        if (MediumImage.isHidden) == true {
            UserDefaults.standard.set(Bool(false), forKey: "MediumHidden")
            UserDefaults.standard.synchronize()
        }else{
            if (MediumImage.isHidden) == false {
                
                UserDefaults.standard.set(Bool(true), forKey: "EasyHidden")
                UserDefaults.standard.set(Bool(true), forKey: "StandardHidden")
                UserDefaults.standard.set(Bool(false), forKey: "MediumHidden")
                UserDefaults.standard.set(Bool(true), forKey: "HardHidden")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    @IBAction func hard(_ sender: AnyObject) {
        
        StandardImage.isHidden = true
        EeasyImage.isHidden = true
        MediumImage.isHidden = true
        HardImage.isHidden = false
        
        if (HardImage.isHidden) == true {
            UserDefaults.standard.set(Bool(false), forKey: "HardHidden")
            UserDefaults.standard.synchronize()
        }else{
            if (HardImage.isHidden) == false {
                
                UserDefaults.standard.set(Bool(true), forKey: "EasyHidden")
                UserDefaults.standard.set(Bool(true), forKey: "StandardHidden")
                UserDefaults.standard.set(Bool(true), forKey: "MediumHidden")
                UserDefaults.standard.set(Bool(false), forKey: "HardHidden")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SavedSettings"{
       
        let destination = segue.destination as! ViewController
            
        destination.Div = UserDefaults.standard.bool(forKey: "DivOnOff")
        destination.Sub = UserDefaults.standard.bool(forKey: "SubOnOff")
        destination.Mul = UserDefaults.standard.bool(forKey: "MulOnOff")
        destination.Add = UserDefaults.standard.bool(forKey: "AddOnOff")
            
        destination.sound = UserDefaults.standard.bool(forKey: "SoundOnOff")
            
        destination.Easy = UserDefaults.standard.bool(forKey: "EasyHidden")
        destination.Standard = UserDefaults.standard.bool(forKey: "StandardHidden")
        destination.Medium = UserDefaults.standard.bool(forKey: "MediumHidden")
        destination.Hard = UserDefaults.standard.bool(forKey: "HardHidden")
            
            
            
            if EeasyImage.isHidden == false {
                
                destination.EasyX = EasyX
            }
            
        }
        
    }
}
