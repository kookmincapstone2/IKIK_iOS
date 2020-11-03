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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 {
            //                self.view.frame.origin.y -= keyboardSize.height
            self.view.frame.origin.y -= 100
        }
        //        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            pwTextField.becomeFirstResponder()
        case pwTextField:
            idTextField.becomeFirstResponder()
        case idTextField:
            phoneTextField.becomeFirstResponder()
            
        default:
            textField.resignFirstResponder()
        }
        
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
       
        let parameters = ["email": email,
                          "pw": pw,
                          "name": name,
                          "student_id": student_id,
                          "phone": phone]
        print(parameters)
        networkingService.request(endpoint: "/authorization/signup", parameters: parameters) { [weak self] (result) in
            print(result)
            switch result {
                
            case .success:
//                guard let alert = self?.alertService.alert(message: "\(user.name)님 회원가입 성공") else { return }
//                self?.present(alert, animated: true)
                self?.dismiss(animated: true, completion: nil)
                break
            
            case .failure(let error):
                // alert to fill all parameter
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else { return }
                self?.present(alert, animated: true)
            }
        }
        
    }
}

