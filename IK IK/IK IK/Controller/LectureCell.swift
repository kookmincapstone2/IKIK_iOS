//
//  LectureCell.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/07.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class LectureCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
