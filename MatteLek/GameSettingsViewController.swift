//
//  GameSettingsViewController.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 15/04/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit

class GameSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
}
