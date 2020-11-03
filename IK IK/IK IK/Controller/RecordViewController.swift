//
//  RecordViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/16.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDataSource {
    
    var roomData: Room?
    var dates: [String] = ["9/2 (수)", "9/9 (수)", "9/16 (수)"]
    var images: [String?] = ["checkmark.circle", "xmark.circle", "ellipsis.circle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! AttendanceCell
        
        let date = dates[indexPath.row]
        let image = images[indexPath.row]
        
        cell.dateLabel.text = date
        
        switch image {
            
        case "xmark.circle":
            cell.attendanceImageView.image = UIImage(systemName: "xmark.circle")
            cell.attendanceImageView.tintColor = UIColor.systemRed
            
        case "ellipsis.circle":
            cell.attendanceImageView.image = UIImage(systemName: "ellipsis.circle")
            cell.attendanceImageView.tintColor = UIColor.systemGray4
            
        default:
            cell.attendanceImageView.image = UIImage(systemName: "checkmark.circle")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
