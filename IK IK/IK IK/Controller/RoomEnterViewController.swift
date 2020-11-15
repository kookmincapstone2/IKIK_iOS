//
//  RoomEnterViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class RoomEnterViewController: UIViewController {
    
    var newRoom: Room?
    
    @IBOutlet weak var invitationCodeTextField: FormTextField!
    
    let networkingService = NetworkingService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func didTapCreateButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let code = invitationCodeTextField.text
            else { return }
        
        roomEnteringRequest(userId: userId, code: code)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func roomEnteringRequest(userId: String, code: String) {
        let parameters = ["user_id": userId, "invite_code": code]
        
        networkingService.request(endpoint: "/room/member/management", method: "POST", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let room):
                self?.newRoom = room as? Room
                self?.performSegue(withIdentifier: "unwindToMainVC", sender: self)
                
            case .failure(let error):
                // did not enter any room yet
                print("creating room error", error)
                break
            }
            self?.dismiss(animated: true, completion: nil)
        })
    }
}
