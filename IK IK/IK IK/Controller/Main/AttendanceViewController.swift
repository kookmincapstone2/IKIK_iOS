//
//  AttendanceViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/16.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var attendanceRateLabel: UILabel!
    
    var roomData: Room?
    var dates: [String] = ["2020년 9월 2일 (수)", "2020년 9월 9일 (수)", "2020년 9월 16일 (수)", "2020년 9월 23일 (수)"
                            , "2020년 9월 30일 (수)", "2020년 10월 7일 (수)"]
    var images: [String?] = ["checkmark.circle", "xmark.circle", "ellipsis.circle", "checkmark.circle", "checkmark.circle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = roomData?.title
        detailLabel.text = roomData?.inviteCode
        // TODO - 출석일수 받아오게
        let days = 5
        let total = 30
        let rate = round(Double(days*10^3) / Double(total) * 10) / 10
        attendanceRateLabel.text = "출석율 \(days)/\(total) ( \(rate)% )"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editView" {
            let destination = segue.destination as! RoomEditViewController
            destination.roomData = roomData
        }
    }
}
