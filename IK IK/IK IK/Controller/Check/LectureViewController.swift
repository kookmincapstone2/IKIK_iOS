//
//  LectureViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/11/24.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController, UICollectionViewDataSource {

    var lectures = ["캡스톤 디자인 프로젝트", "컴퓨터비전", "모바일프로그래밍", "알고리즘"]
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lectures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LectureCollectionCell", for: indexPath)
        
        return cell
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
