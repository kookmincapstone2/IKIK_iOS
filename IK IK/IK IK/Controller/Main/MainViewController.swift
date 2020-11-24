//
//  MainViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myRoomList = [Room]()
    var selectedRoom: Room?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    
    let networkingService = NetworkingService()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload),
                                               name: NSNotification.Name(rawValue: "reloadRoomData"),
                                               object: nil)
        
        if let name = UserDefaults.standard.string(forKey: "username"),
            let userId = UserDefaults.standard.string(forKey: "userid") {
            
            nameLabel.text = "안녕하세요, \(name.capitalized)님"
            getMyRooms(userId: Int(userId)!)
        }
        
        if let rank = UserDefaults.standard.string(forKey: "rank") {
            if rank == "teacher" { enterButton.isHidden = true }
            else { createButton.isHidden = true }
        }
        
    }
    
    @objc func reload(_ notification: Notification) {
        print("reload")
        if let room = notification.userInfo?["room"] as? Room {
            if let found = myRoomList.firstIndex(where: { $0.roomId == room.roomId }) {
                myRoomList[found] = room
            }
        }
        
        self.mainTableView.reloadData()
    }
    
    // MARK: - Networking [get rooms]
    @IBAction func getNewRoomData(_ sender: UIStoryboardSegue){
        if let from = sender.source as? RoomCreateViewController {
            myRoomList.append(from.newRoom!)
            
        } else if let from = sender.source as? RoomEnterViewController {
            myRoomList.append(from.newRoom!)
            
        } else if let from = sender.source as? RoomEditViewController {
            print("RoomEditViewController", from)
            if let found = myRoomList.firstIndex(where: { $0.roomId == from.roomData!.roomId }) {
                print("deleted")
                myRoomList.remove(at: found)
            }
        }
        
        mainTableView.reloadData()
    }
    
    func getMyRooms(userId: Int) {
        let parameters = ["user_id": userId]
        networkingService.request(endpoint: "/room/member/management", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let roomList):
                self?.myRoomList = (roomList as? [Room])!.sorted(by: { $0.title < $1.title})
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRoomData"), object: nil)
                
            case .failure(let error):
                self?.myRoomList = []
                print("getting room error", error) // did not enter any room yet
                break
            }
        })
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureCell", for: indexPath) as! LectureCell
        
        let roomTemp = myRoomList[indexPath.row]
        
        cell.titleLabel.text = roomTemp.title
        cell.timeLabel.text = "최대 정원: " + String(roomTemp.maximumPopulation) + " 명"
        cell.detailLabel.text = "초대 코드: " + (roomTemp.inviteCode ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row at")
        selectedRoom = myRoomList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if let rank = UserDefaults.standard.string(forKey: "rank") {
            switch rank {
            case "teacher":
                print("perform teacher")
                performSegue(withIdentifier: "teacherView", sender: tableView)
                
            case "student":
                print("perform student")
                performSegue(withIdentifier: "studentView", sender: tableView)
                
            default:
                print("rank error")
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "teacherView" {
            let destination = segue.destination as! StudentsViewController
            destination.roomData = selectedRoom
            
        } else if segue.identifier == "studentView" {
            let destination = segue.destination as! AttendanceViewController
            destination.roomData = selectedRoom
        }
    }
    
    
    //     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            myRoomList.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
}