//
//  InfoViewController.swift
//  MatteLek
//
//  Created by TIMMY KONNEUS on 21/06/17.
//  Copyright © 2017 TIMMY KONNEUS. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }


    @IBAction func dismiss(_ sender: AnyObject) {
        
         dismiss(animated: true, completion: nil)
    }
    @IBAction func GotIt(_ sender: AnyObject) {
        
         dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
