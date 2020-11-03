//
//  RoomEditViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/27.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class RoomEditViewController: UIViewController {

    @IBOutlet weak var titleTextField: FormTextField!
    @IBOutlet weak var populationTextField: FormTextField!
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        titleTextField.text =
//        populationTextField.text =
    }
    
    // MARK: - IBActions
    @IBAction func didTapCreateButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let title = titleTextField.text,
            let population = populationTextField.text
            else { return }
        
        roomEditRequest(userId: userId, title: title, population: population)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func roomEditRequest(userId: String, title: String, population: String) {
        let parameters = ["user_id": userId, "title": title, "maximum_population": population]
        
        networkingService.handleRoom(method: "PUT", endpoint: "/room/management", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let room):
                //                invitation code sharing modal, using clipboard
                //                UIPasteboard.general.string
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRoomData"), object: nil)
                
            case .failure(let error):
                // did not enter any room yet
                print("creating room error", error)
                break
            }
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
}
