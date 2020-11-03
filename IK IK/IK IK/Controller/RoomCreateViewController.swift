//
//  RoomCreateViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/19.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class RoomCreateViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var populationTextField: UITextField!
    
    var newRoom: Room?
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func didTapCreateButton(_ sender: Any) {
        
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let title = titleTextField.text,
            let population = populationTextField.text
            else { return }
        
        roomCreationRequest(userId: userId, title: title, population: population)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func roomCreationRequest(userId: String, title: String, population: String) {
        let parameters = ["user_id": userId, "title": title, "maximum_population": population]
        
        networkingService.handleRoom(method: "POST", endpoint: "/room/management", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let room):
                //                invitation code sharing modal, using clipboard
                //                UIPasteboard.general.string
                self?.newRoom = room!
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
