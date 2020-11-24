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
    var students = [String]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var studentTableView: UITableView!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.update),
                                               name: NSNotification.Name(rawValue: "updateRoomData"),
                                               object: nil)
        
        titleLabel.text = roomData?.title
        getStudents(roomId: roomData!.roomId)
    }
    
    func getStudents(roomId: Int) {
        let parameters = ["room_id": roomId]
        networkingService.request(endpoint: "/room/member/all", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let studentList):
                self?.students = (studentList as! [User])[1...].map({$0.name}).sorted(by: <)
                self?.detailLabel.text = "\(self!.students.count) / \(self!.roomData!.maximumPopulation) 명 참여중"
                self?.studentTableView.reloadData()
                
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
            detailLabel.text = "\(students.count) / \(roomData.maximumPopulation) 명 참여중"
        }
    }
    
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
        
        cell.idLabel.text = "2020101\(indexPath.row)"
        
        let name = students[indexPath.row]
        cell.nameLabel.text = name
        
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
