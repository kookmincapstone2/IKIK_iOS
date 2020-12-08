//
//  LectureViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/24.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var roomList = [Room]()
    var selected: Room?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LectureCell", bundle: .main), forCellWithReuseIdentifier: "LectureCell")
        collectionView.layer.cornerRadius = 10
        setupFlowLayout()
        
        if let userId = UserDefaults.standard.string(forKey: "userid") {
            getMyRooms(userId: Int(userId)!)
        }
    }
    
    func getMyRooms(userId: Int) {
        let parameters = ["user_id": userId]
        
        networkingService.request(endpoint: "/room/member/management", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success(let roomList):
                self?.roomList = roomList as! [Room]
                self?.roomList.sort(by: {$0.title < $1.title})
                self?.collectionView.reloadData()
                
            case .failure(let error):
                self?.roomList = []
                print("getting room error", error) // did not enter any room yet
                break
            }
        })
    }
    
    
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.roomList.count == 0) {
            self.collectionView.setEmptyMessage("아직 출석할 수업이 없어요 😅")
        } else {
            self.collectionView.restore()
        }
        
        return roomList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LectureCell", for: indexPath) as? LectureCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true;
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.9
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.layer.cornerRadius).cgPath

        
        cell.titleLabel.text = roomList[indexPath.row].title
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        cell.populationLabel.text = "\(roomList[indexPath.row].maximumPopulation)명"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selected = self.roomList[indexPath.row]
        
        if let rank = UserDefaults.standard.string(forKey: "rank"), rank == "teacher" {
            self.performSegue(withIdentifier: "toPassCreateVC", sender: self)
        } else {
            let studentCheckVC = (self.storyboard?.instantiateViewController(withIdentifier: "studentCheckVC")) as! StudentCheckViewController
            studentCheckVC.roomTitle = selected?.title
            studentCheckVC.roomId = selected?.roomId
            
            self.navigationController?.pushViewController(studentCheckVC, animated: true)
        }
    }
    
    private func setupFlowLayout() {
        // CollectionView Cell 크기 바꾸는 함수
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 24
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.80 , height: halfWidth * 0.80)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPassCreateVC" {
            let destination = segue.destination as! PassCreateViewController
            
            destination.roomData = selected
            destination.previousVC = self
        }
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
