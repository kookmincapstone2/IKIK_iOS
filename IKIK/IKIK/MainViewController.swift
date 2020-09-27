//
//  MainViewController.swift
//  IKIK
//
//  Created by 서민주 on 2020/09/27.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = user?.name {
            
            nameLabel.text = "Welcome, \(name.capitalized)"
        }
    }
}
