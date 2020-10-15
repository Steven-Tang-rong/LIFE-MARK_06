//
//  dayPageTableViewCell.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/10/9.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class dayPageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var showSetTimeLabel: UILabel!
    
    @IBOutlet weak var dayTitleLabel: UILabel!
    
    @IBOutlet weak var dayMainTaskLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
