//
//  AttendanceViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/16.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController, UITableViewDataSource {
    
    var userId: String?
    var roomData: Room?
    var dates = [String]()
    var images = [String?]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var attendanceRateLabel: UILabel!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let rank = UserDefaults.standard.string(forKey: "rank"), rank == "teacher" {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.editBarButtonItem
            userId = UserDefaults.standard.string(forKey: "userid")
        }
        
        titleLabel.text = roomData?.title
        detailLabel.text = roomData?.inviteCode
        
        if let roomId = roomData?.roomId {
            getAttendances(userId: userId!, roomId: String(roomId))
        }
    }
    
    func getAttendances(userId: String, roomId: String) {
        let parameters = ["user_id": userId, "room_id": roomId]
        networkingService.request(endpoint: "/room/attendance/check/all", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let attendanceDict):
                
                for (date, isChecked) in attendanceDict![0] as! [String:Bool] {
                    self?.dates.append(date)
                    
                    let image: String = isChecked ? "checkmark.circle" : "xmark.circle"
                    self?.images.append(image)
                }
                self?.tableView.reloadData()
                self?.updateRate()
                
            case .failure(let error):
                self?.dates = []
                self?.images = []
                print("getting student list error", error) // did not enter any room yet
                break
            }
        })
    }
    
    func updateRate() {
        let days = images.filter { $0 == "checkmark.circle" }.count
        let total = dates.count
        let rate = round(Double(days * 100) / Double(total) * 10) / 10
        
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
        cell.attendanceImageView.image = UIImage(systemName: image!)
        
        switch image {
            
        case "xmark.circle":
            cell.attendanceImageView.tintColor = UIColor.systemRed
            
//        case "ellipsis.circle":
//            cell.attendanceImageView.image = UIImage(systemName: "ellipsis.circle")
//            cell.attendanceImageView.tintColor = UIColor.systemGray4
            
        default:
            break
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editView" {
            let destination = segue.destination as! RoomEditViewController
            destination.roomData = roomData
        }
    }
}
