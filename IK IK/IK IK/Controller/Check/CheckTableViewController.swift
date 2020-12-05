//
//  CheckTableViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/22.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class CheckTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var titleText = ""
    var checked: [String] = ["가나다", "라마바", "사아자"]
    var unchecked: [String] = ["차카타", "파하"]
    
    let sections: [String] = ["출석", "미출석"]
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var populatitonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = title!
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return checked.count
        } else if section == 1 {
            return unchecked.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckCell
        
        if indexPath.section == 0 {
            cell.nameLabel.text = "\(checked[indexPath.row])"
            
        } else if indexPath.section == 1 {
            cell.nameLabel.text = "\(unchecked[indexPath.row])"
            
        } else {
            return UITableViewCell()
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
