//
//  MenuViewController.swift
//  SWiP2
//
//  Created by Mathieu Harribey on 08/11/2017.
//  Copyright © 2017 Mathieu Harribey. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var supprimerBtn: UIView!
    @IBOutlet weak var tutorielBtn: UIView!
    @IBOutlet weak var aboutBtn: UIView!
    @IBOutlet weak var spendBtn: UIView!
    
    var savedArray = UserDefaults.standard.object(forKey: "Result") as? [[String: String]]

    @IBAction func supprimerAll(_ sender: Any) {
        let alert = UIAlertController(title: "Réinitialiser", message: "Vous allez supprimés tous vos tickets enregistrés.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: {
            (nil) in
        }))
        alert.addAction(UIAlertAction(title: "Confirmer", style: .default, handler:
            { (nil) in
                self.savedArray = nil
                UserDefaults.standard.set(nil, forKey: "total")
                UserDefaults.standard.set(self.savedArray, forKey: "Result")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorielBtn.layer.cornerRadius = 8
        supprimerBtn.layer.cornerRadius = 8
        aboutBtn.layer.cornerRadius = 8
        spendBtn.layer.cornerRadius = 8
        
        spendBtn.clipsToBounds = true
        tutorielBtn.clipsToBounds = true
        supprimerBtn.clipsToBounds = true
        aboutBtn.clipsToBounds = true
        
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
