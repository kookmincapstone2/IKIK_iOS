//
//  PassCreateViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/12/03.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class PassCreateViewController: UIViewController {
    
    var roomId: Int?
    var previousVC: UIViewController?
    
    @IBOutlet weak var passNumLabel: FormTextField!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func didTapCreateButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let roomId = roomId,
            let passNum = passNumLabel.text
            else { return }
        
        passNumCreationRequest(userId: userId, roomId: String(roomId), passNum: passNum)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func passNumCreationRequest(userId: String, roomId: String, passNum: String) {
        let parameters = ["user_id": userId, "room_id": roomId, "pass_num": passNum]
        
        networkingService.request(endpoint: "/room/attendance/check", method: "POST", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success:
                let checkTableVC = (self?.storyboard?.instantiateViewController(withIdentifier: "checkTableVC")) as! CheckTableViewController
                
                self?.dismiss(animated: true, completion: {
                    self?.previousVC?.navigationController?.pushViewController(checkTableVC, animated: false)
                })
                
            case .failure(let error):
                // did not enter any room yet
                print("pass num creation error", error)
                break
            }
            self?.dismiss(animated: true, completion: nil)
        })
    }
}
