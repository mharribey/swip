//
//  ViewController.swift
//  SWiP2
//
//  Created by Mathieu Harribey on 08/11/2017.
//  Copyright © 2017 Mathieu Harribey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var savedArray = UserDefaults.standard.object(forKey: "Result") as? [[String: String]]
    var totalSpend = UserDefaults.standard.object(forKey: "total") as? Double ?? 0.0
    var data = 0.0
    
    var height: CGFloat = UITableViewAutomaticDimension
    var maxHeight: [Int] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        scanButton.layer.cornerRadius = 24
        scanButton.clipsToBounds = true
        
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if ((savedArray?.count) != nil){
            return savedArray!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as? BillTableViewCell else {
            fatalError("Can't cast as BillTableViewCell")
        }
        
        cell.billContent.text = savedArray![indexPath.row]["shop"]!
        cell.fullPrice.text = "Le " + savedArray![indexPath.row]["date"]!
        cell.priceList.text = savedArray![indexPath.row]["articlePrice"]
        cell.fullBill.text = savedArray![indexPath.row]["articleList"]
        cell.total.text = savedArray![indexPath.row]["total"]! + " €"
        cell.articleCount.text = savedArray![indexPath.row]["articleCount"]! + " articles"
        
        cell.fullBill.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.fullBill.sizeToFit()
        cell.priceList.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.priceList.sizeToFit()
        
        cell.layer.borderWidth = cell.layer.borderWidth - 15.0

        cell.layer.cornerRadius = 10

        for _ in savedArray![indexPath.row]["articleList"]!{
            maxHeight += [Int(cell.fullBill.bounds.size.height)]
        }

        tableView.rowHeight = CGFloat(maxHeight.max()! + 80)
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.beginUpdates()
        
        if (height == UITableViewAutomaticDimension){
            height = tableView.rowHeight
        } else if (height == tableView.rowHeight){
            height = UITableViewAutomaticDimension
        }
        
        self.tableView.endUpdates()
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if let papapa = Double(savedArray![indexPath.row]["total"]!) {
                print(papapa)
                data = papapa
            } else {
                print("Can't convert to Double")
            }
            
            savedArray!.remove(at: indexPath.row)
            
            UserDefaults.standard.set(savedArray, forKey: "Result")
            UserDefaults.standard.set(totalSpend - data, forKey: "total")
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

