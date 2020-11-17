//
//  StudentsViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/03.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController, UITableViewDataSource {
    
    var roomData: Room?
    var dates: [String] = ["9/2 (수)", "9/9 (수)", "9/16 (수)"]
    var images: [String?] = ["checkmark.circle", "xmark.circle", "ellipsis.circle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.update),
                                               name: NSNotification.Name(rawValue: "updateRoomData"),
                                               object: nil)
        
        titleLabel.text = roomData?.title
        detailLabel.text = "\(names.count) / \(roomData!.maximumPopulation) 명 참여중"
    }
    
    func getStudents(userId: Int) {
        let parameters = ["user_id": userId]
        networkingService.request(endpoint: "/room/management", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let studentList):
                self?.students = (studentList as? [String])!.sorted(by: <)
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRoomData"), object: nil)
                
            case .failure(let error):
                self?.students = []
                print("getting student list error", error) // did not enter any room yet
                break
            }
        })
    }
    
    @objc func update(_ notification: Notification) {
        if let roomData = notification.userInfo?["room"] as? Room {
            titleLabel.text = roomData.title
            detailLabel.text = "\(names.count) / \(roomData.maximumPopulation) 명 참여중"
        }
    }
    
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! AttendanceCell
        
        //        let date = dates[indexPath.row]
        //        let image = images[indexPath.row]
        //
        //        cell.dateLabel.text = date
        //
        //        switch image {
        //
        //        case "xmark.circle":
        //            cell.attendanceImageView.image = UIImage(systemName: "xmark.circle")
        //            cell.attendanceImageView.tintColor = UIColor.systemRed
        //
        //        case "ellipsis.circle":
        //            cell.attendanceImageView.image = UIImage(systemName: "ellipsis.circle")
        //            cell.attendanceImageView.tintColor = UIColor.systemGray4
        //
        //        default:
        //            cell.attendanceImageView.image = UIImage(systemName: "checkmark.circle")
        //        }
        
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
        if segue.identifier == "codeView" {
            let destination = segue.destination as! InviteCodeViewController
            destination.code = roomData?.inviteCode
            
        } else if segue.identifier == "editView" {
            let destination = segue.destination as! RoomEditViewController
            destination.roomData = roomData
        }
    }
}
