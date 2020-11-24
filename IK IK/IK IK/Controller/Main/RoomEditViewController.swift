//
//  RoomEditViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/27.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class RoomEditViewController: UIViewController {
    
    var roomData: Room?
    
    @IBOutlet weak var titleTextField: FormTextField!
    @IBOutlet weak var populationTextField: FormTextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = roomData?.title
        populationTextField.text = (roomData?.maximumPopulation).map{ String($0) }
        
        if let rank = UserDefaults.standard.string(forKey: "rank") {
            if rank == "student" {
                titleTextField.isUserInteractionEnabled = false
                populationTextField.isUserInteractionEnabled = false
                deleteButton.isHidden = true
            } else {
                leaveButton.isHidden = true
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapCreateButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let title = titleTextField.text,
            let population = populationTextField.text,
            let roomId = roomData?.roomId
            else { return }
        
        roomEditRequest(userId: userId, roomId: String(roomId), title: title, population: population)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let roomId = roomData?.roomId
            else { return }
        
        roomDeleteRequest(userId: userId, roomId: String(roomId))
    }
    
    @IBAction func didTapLeaveButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let roomId = roomData?.roomId
            else { return }
        
        roomLeaveRequest(userId: userId, roomId: String(roomId))
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func roomEditRequest(userId: String, roomId: String, title: String, population: String) {
        
        let parameters = ["user_id": userId, "room_id": roomId, "title": title, "maximum_population": population]
        
        networkingService.request(endpoint: "/room/management", method: "PUT", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
            case .success(let room):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateRoomData"),
                                                object: nil, userInfo: ["room": room!])
                
            case .failure(let error):
                // did not enter any room yet
                print("creating room error", error)
                break
            }
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    func roomDeleteRequest(userId: String, roomId: String) {
        
        let parameters = ["user_id": userId, "room_id": roomId]
        
        networkingService.request(endpoint: "/room/management", method: "DELETE", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
            case .success:
                // TODO: delete alert, pop segue
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRoomData"), object: nil)
                self?.performSegue(withIdentifier: "unwindToMainVC", sender: self)
                
            case .failure(let error):
                print("deleting room error", error)
                break
            }
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    func roomLeaveRequest(userId: String, roomId: String) {
        
        let parameters = ["user_id": userId, "room_id": roomId]
        
        networkingService.request(endpoint: "/room/member/management", method: "DELETE", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
            case .success:
                // TODO: delete alert, pop segue
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRoomData"), object: nil)
                self?.performSegue(withIdentifier: "unwindToMainVC", sender: self)
                
            case .failure(let error):
                print("deleting room error", error)
                break
            }
            self?.dismiss(animated: true, completion: nil)
        })
    }
}
