//
//  PassCreateViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/12/03.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class PassCreateViewController: UIViewController {
    
    var roomData: Room?
    var previousVC: UIViewController?
    
    @IBOutlet weak var passNumTextField: FormTextField!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapCreateButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let roomId = roomData?.roomId,
            let passNum = passNumTextField.text
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
                    checkTableVC.roomData = self!.roomData
                    checkTableVC.passNum = self!.passNumTextField.text!
                    
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
