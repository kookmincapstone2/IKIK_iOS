//
//  StudentCell.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/03.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var attendancePercentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
