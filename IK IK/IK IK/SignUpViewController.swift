//
//  SignUpViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // TODO: delegate storyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let pw = pwTextField.text,
            let student_id = idTextField.text,
            let phone = phoneTextField.text
            else { return }
        
        formDataRequest(name: name, email: email, pw: pw, student_id: student_id, phone: phone)
    }
    
    func formDataRequest(name: String, email: String, pw: String, student_id: String, phone: String) {
       
        let parameters = ["name": name,
                          "email": email,
                          "pw": pw,
                          "student_id": student_id,
                          "phone": phone]
        
        networkingService.request(endpoint: "/authurization/signup", parameters: parameters) { [weak self] (result) in
            print(result)
            switch result {
                
            case .success(let user):
                // dismiss segue
                break
            
            case .failure(let error):
                // alert to fill all parameter
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else { return }
                self?.present(alert, animated: true)
            }
        }
        
    }
}

