//
//  ScoreboardView.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 19/04/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ScoreboardView: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var HighScore: UILabel!
    
    var RetrievedScore = Int()
    var RetrivedHighscore = Int()
    
    @IBOutlet weak var highscorelabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var bannerView2: GADBannerView!
    @IBAction func DissmissView(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "annon") == false {
        var ref = FIRDatabase.database().reference(fromURL: "https://mathhack-7451e.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(uid!).observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let highscore = value?["highscore"] as? Int
            if highscore != nil {
            self.RetrivedHighscore = highscore!
            }
        })
        }
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = "ca-app-pub-1797867231153138/7983751209"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(request)
        
        let request2 = GADRequest()
        request2.testDevices = [kGADSimulatorID]
        bannerView2.adUnitID = "ca-app-pub-1797867231153138/5427237601"
        bannerView2.rootViewController = self
        bannerView2.delegate = self
        bannerView2.load(request)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        Score.text = String(RetrievedScore)
        HighScore.text = String(RetrivedHighscore)
        
        highscorelabel.text = "Your Highscore"
        
        if RetrivedHighscore == RetrievedScore {
            
           highscorelabel.text = "New Highscore!"
            
        }
        
        if UserDefaults.standard.bool(forKey: "annon") == true {
            
            highscorelabel.text = "Log in to save your score"
            HighScore.isHidden = true
        }
        
    }


}
