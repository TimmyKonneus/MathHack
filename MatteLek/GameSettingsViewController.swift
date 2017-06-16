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
    
    var OnOff = Bool(true)

    @IBAction func OnOff(_ sender: AnyObject) {
     
       if (sender.isOn) == true {
            
            OnOff = true
        
        }
        else
        {
        if (sender.isOn) == false {
                
            OnOff = false
            
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
        

    
        
      if OnOff == true {
            
         SoundSwitch.isOn = true
           // SoundSwitch.setOn(true, animated: true)
        }
        else
            if OnOff == false {
            
                SoundSwitch.isOn = false
           // SoundSwitch.setOn(false, animated: true)
        }
        
       print(OnOff)

        StandardImage.isHidden = false
        EeasyImage.isHidden = true
        MediumImage.isHidden = true
        HardImage.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        
    }
 
    @IBAction func easy(_ sender: AnyObject) {
        
        StandardImage.isHidden = true
        EeasyImage.isHidden = false
        MediumImage.isHidden = true
        HardImage.isHidden = true
        print(OnOff)
    }

    @IBAction func medium(_ sender: AnyObject) {
        
        StandardImage.isHidden = true
        EeasyImage.isHidden = true
        MediumImage.isHidden = false
        HardImage.isHidden = true
    }
    
    @IBAction func hard(_ sender: AnyObject) {
        
        StandardImage.isHidden = true
        EeasyImage.isHidden = true
        MediumImage.isHidden = true
        HardImage.isHidden = false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SavedSettings"{
       
            let destination = segue.destination as! ViewController
            
          
         destination.sound = OnOff
            
            if EeasyImage.isHidden == false {
                
                destination.EasyX = EasyX
            }
            
        }
        
    }
}
