//
//  InviteCodeViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/11.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class InviteCodeViewController: UIViewController {

    var code: String?
    let alertService = AlertService()
    
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.text = code
    }
    
    @IBAction func didTapCopyButton(_ sender: Any) {
        UIPasteboard.general.string = code
        let alert = alertService.alert(message: "복사 완료!")
        self.present(alert, animated: true)
    }
    
}
