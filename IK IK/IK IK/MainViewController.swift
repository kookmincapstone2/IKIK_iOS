//
//  MainViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = user?.name {
            
            nameLabel.text = "Welcome, \(name.capitalized)"
        }
    }
}
