//
//  LoginViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLogin()
    }
    
    func autoLogin() {
        if let email = UserDefaults.standard.string(forKey: "email") {
            if let pw = UserDefaults.standard.string(forKey: "pw") {
                formDataRequest(email: email, pw: pw)
            }
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        
        guard
            let email = emailTextField.text,
            let pw = pwTextField.text
            else { return }
        
        formDataRequest(email: email, pw: pw)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            pwTextField.becomeFirstResponder()
        } else {
            pwTextField.resignFirstResponder()
        }
        return true
    }
    
    func formDataRequest(email: String, pw: String) {
        let parameters = ["email": email,
                          "pw": pw]
        
        networkingService.request(endpoint: "/authorization/login", method: "POST", parameters: parameters) { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let user):
                
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(pw, forKey: "pw")
                UserDefaults.standard.set((user as? User)?.name, forKey: "username")
                UserDefaults.standard.set((user as? User)?.userId, forKey: "userid")
                UserDefaults.standard.set((user as? User)?.rank, forKey: "rank")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                
            case .failure(let error):
                
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else { return }
                self?.present(alert, animated: true)
            }
        }
    }
    
}
