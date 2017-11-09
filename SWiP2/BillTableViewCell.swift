//
//  BillTableViewCell.swift
//  SWiP2
//
//  Created by Mathieu Harribey on 09/11/2017.
//  Copyright © 2017 Mathieu Harribey. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    @IBOutlet weak var billContent: UILabel!
    @IBOutlet weak var fullPrice: UILabel!
    @IBOutlet weak var fullBill: UILabel!
    @IBOutlet weak var priceList: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var articleCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
