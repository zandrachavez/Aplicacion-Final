//
//  TableViewCell03.swift
//  MyNailsApp
//
//  Created by mac on 09/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TableViewCell03: UITableViewCell {
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    //@IBOutlet weak var lblHour: UILabel!
    //@IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
