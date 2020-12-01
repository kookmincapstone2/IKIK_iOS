//
//  LectureViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/24.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

//    var lectures = ["캡스톤 디자인 프로젝트", "컴퓨터비전", "모바일프로그래밍", "알고리즘", "캡스톤 디자인 프로젝트", "컴퓨터비전", "모바일프로그래밍", "알고리즘"]
    var lectures = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LectureCell", bundle: .main), forCellWithReuseIdentifier: "LectureCell")
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
                self?.lectures = (roomList as? [Room])!.map {$0.title}.sorted()
                self?.collectionView.reloadData()
                
            case .failure(let error):
                self?.lectures = []
                print("getting room error", error) // did not enter any room yet
                break
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lectures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LectureCell", for: indexPath) as? LectureCell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = lectures[indexPath.row]
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let checkTableVC = (self.storyboard?.instantiateViewController(withIdentifier: "checkTableVC")) as! CheckTableViewController

        checkTableVC.title = self.lectures[indexPath.row]

       self.navigationController?.pushViewController(checkTableVC, animated: true)
    }
    
    private func setupFlowLayout() {    // CollectionView Cell 크기 바꾸는 함수
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero 
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 24
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.85 , height: halfWidth * 0.85)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
