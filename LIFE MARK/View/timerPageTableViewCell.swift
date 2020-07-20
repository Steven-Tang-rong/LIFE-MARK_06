//
//  timerPageTableViewCell.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/7/16.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class timerPageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var showSetTime: UILabel!
    
    @IBOutlet weak var timerTitle: UILabel!
    
    @IBOutlet weak var timerMainTask: UILabel!
    
    
    @IBOutlet weak var timerSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
