//
//  LoginViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        
        guard
            let email = emailTextField.text,
            let pw = pwTextField.text
            else { return }
        
        formDataRequest(email: email, pw: pw)
        //        jsonRequest(email: email, pw: pw)
    }
    
    func formDataRequest(email: String, pw: String) {
        let parameters = ["email": email,
                          "pw": pw]
        networkingService.request(endpoint: "/authorization/login", parameters: parameters) { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let user):
                //                self?.performSegue(withIdentifier: "loginSegue", sender: user)
                let mainScreen = self?.storyboard!.instantiateViewController(withIdentifier: "MainScreen") as? MainViewController
                self?.navigationController?.pushViewController(mainScreen!, animated: true)
                mainScreen!.user = user
                
            case .failure(let error):
                
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else { return }
                self?.present(alert, animated: true)
            }
        }
    }
    
    func jsonRequest(email: String, pw: String) {
        
        let login = Login(email: email, pw: pw)
        
        networkingService.request(endpoint: "/authorization/login", loginObject: login) { [weak self] (result) in
            
            switch result {
                
            case .success(let user): self?.performSegue(withIdentifier: "loginSegue", sender: user)
                
            case .failure(let error):
                
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else { return }
                self?.present(alert, animated: true)
            }
        }
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if let mainAppVC = segue.destination as? MainViewController, let user = sender as? User {
    //
    //            mainAppVC.user = user
    //        }
    //    }
}
