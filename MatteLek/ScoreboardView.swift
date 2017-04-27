//
//  ScoreboardView.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 19/04/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit
import Firebase

class ScoreboardView: UIViewController {

    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var HighScore: UILabel!
    
    var RetrievedScore = Int()
    var RetrivedHighscore = Int()
    
    @IBOutlet weak var highscorelabel: UILabel!
    
    @IBAction func DissmissView(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        var ref = FIRDatabase.database().reference(fromURL: "https://mathhack-7451e.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(uid!).observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let highscore = value?["highscore"] as? Int
            if highscore != nil {
            self.RetrivedHighscore = highscore!
            }
        })
        
     
        
       //Score.text = String(RetrievedScore)
        //HighScore.text = String(RetrivedHighscore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        Score.text = String(RetrievedScore)
         HighScore.text = String(RetrivedHighscore)
        
        if RetrivedHighscore == RetrievedScore {
            
           highscorelabel.text = "New highscore!"
            
        }
    }


}
