//
//  CheckTableViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/22.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class CheckTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var roomData: Room?
    var roomId: String?
    var passNum = ""
    
    var checked = [String]()
    var unchecked = [String]()
    var timer: Timer?
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passNumLabel: UILabel!
    @IBOutlet weak var populatitonLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let sections: [String] = ["출석", "미출석"]
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = roomData?.title
        passNumLabel.text = "출석 코드: \(passNum)"
        
        

        if let userId = UserDefaults.standard.string(forKey: "userid") {
            roomId = String(roomData!.roomId)
            
            getAttendanceStatus(userId: userId, roomId: roomId!)
            populatitonLabel.text = "\(checked.count) / \(checked.count + unchecked.count) 명 출석중"
            
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoRefresh), userInfo: ["userId": userId], repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func autoRefresh(_ notification: NSNotification) {
        getAttendanceStatus(userId: notification.userInfo?["userId"] as! String, roomId: roomId!)
    }
    
    func getAttendanceStatus(userId: String, roomId: String) {
        
        let parameters = ["user_id": userId, "room_id": roomId]
        
        networkingService.request(endpoint: "/room/attendance/check", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let students):
                self?.checked = (students?[0] as! [String]).sorted()
                self?.unchecked = (students?[1] as! [String]).sorted()
                self?.populatitonLabel.text = "\(self!.checked.count) / \(self!.checked.count + self!.unchecked.count) 명 출석중"
                self?.tableView.reloadData()
                
            case .failure(let error):
                self?.checked = []
                self?.unchecked = []
                print("getting student's attendance error", error) // did not enter any room yet
                break
            }
        })
    }
    
    @IBAction func didTapCompleteButton(_ sender: Any) {
        guard let userId = UserDefaults.standard.string(forKey: "userid")
            else { return }
        
        closeAttendance(userId: userId, roomId: roomId!)
            
    }
    
    func closeAttendance(userId: String, roomId: String) {
        
        let parameters = ["user_id": userId, "room_id": roomId]
        
        networkingService.request(endpoint: "/room/attendance/check/close", method: "PUT", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("closing attendance error", error) // did not enter any room yet
                break
            }
        })
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return checked.count
        } else if section == 1 {
            return unchecked.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckCell
        
        if indexPath.section == 0 {
            cell.nameLabel.text = "\(checked[indexPath.row])"
            
        } else if indexPath.section == 1 {
            cell.nameLabel.text = "\(unchecked[indexPath.row])"
            
        } else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
