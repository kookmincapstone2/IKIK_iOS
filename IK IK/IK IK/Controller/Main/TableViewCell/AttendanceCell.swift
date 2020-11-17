//
//  AttendanceCell.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/22.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class AttendanceCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var attendanceImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
