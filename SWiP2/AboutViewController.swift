//
//  AboutViewController.swift
//  SWiP2
//
//  Created by Mathieu Harribey on 08/11/2017.
//  Copyright © 2017 Mathieu Harribey. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var motivationButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motivationButton.layer.cornerRadius = 8
        motivationButton.clipsToBounds = true
        
        let topColor = UIColor(red: 103/255, green: 125/255, blue: 253/255, alpha: 1)
        let bottomColor = UIColor(red: 63/255, green: 91/255, blue: 254/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.1, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
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
