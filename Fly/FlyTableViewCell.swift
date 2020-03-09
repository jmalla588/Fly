//
//  FlyTableViewCell.swift
//  Fly
//
//  Created by Janak Malla on 3/7/20.
//  Copyright © 2020 Janak Malla. All rights reserved.
//

import UIKit

class FlyTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var flySwitch: CustomSwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
