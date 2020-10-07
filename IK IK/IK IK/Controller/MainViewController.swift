//
//  MainViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
    
    var user: User?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let name = user?.name {
//
//            nameLabel.text = "Welcome, \(name.capitalized)"
//        }
        if let name = UserDefaults.standard.string(forKey: "username") {
            
            nameLabel.text = "Welcome, \(name.capitalized)"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LectureCell
        
        cell.titleLabel.text = "수업명"
        cell.timeLabel.text = "요일 00:00~24:59"
        cell.detailLabel.text = "OOO교수님 7호관 424호"
        return cell
    }
}
