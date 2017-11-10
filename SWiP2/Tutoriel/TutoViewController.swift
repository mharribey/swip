//
//  TutoViewController.swift
//  SWiP2
//
//  Created by Mathieu Harribey on 10/11/2017.
//  Copyright © 2017 Mathieu Harribey. All rights reserved.
//

import UIKit

class TutoViewController: UIViewController {
    
    let data = UserDefaults.standard

    @IBOutlet weak var endTuto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endTuto.layer.cornerRadius = 8
        endTuto.clipsToBounds = true
    }
    
    @IBAction func changeData(_ sender: Any) {
        self.data.set("VC1", forKey: "controller")
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
