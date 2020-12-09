//
//  StudentCheckViewController.swift
//  IK IK
//
//  Created by 서민주 on 2020/12/05.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit
import AVFoundation

class StudentCheckViewController: UIViewController {

    var roomTitle: String?
    var roomId: Int?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passNumTextField: UITextField!
//    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    var blurEffectView: UIVisualEffectView {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let outerVisualEffectView = UIVisualEffectView(effect: blurEffect)
        outerVisualEffectView.frame = self.view.frame
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let innerVisualEffectView = UIVisualEffectView(effect: vibrancyEffect)
        innerVisualEffectView.frame = self.view.frame
        
        outerVisualEffectView.contentView.addSubview(innerVisualEffectView)

        let image = UIImage.init(systemName: "checkmark.seal.fill")
        let imageView = UIImageView()
        imageView.frame = CGRect(x: UIScreen.main.bounds.height/8, y: UIScreen.main.bounds.width/1.5, width: 170, height: 170)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.init(named: "AppMainColor")

        innerVisualEffectView.contentView.addSubview(imageView)
        
        let label = UILabel()
        label.text = "출석요청이 완료되었습니다"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        label.frame = self.view.frame
        label.frame.origin = CGPoint(x:UIScreen.main.bounds.height - label.frame.height, y:UIScreen.main.bounds.width - label.frame.width/1.2)
        innerVisualEffectView.contentView.addSubview(label)
        
        return outerVisualEffectView
    }
    
    let session = AVCaptureSession()
    let networkingService = NetworkingService()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "'\(roomTitle!)'"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func didTapCheckButton(_ sender: Any) {
        guard
            let userId = UserDefaults.standard.string(forKey: "userid"),
            let roomId = roomId,
            let passNum = passNumTextField.text
            else { return }
        
        attendanceRequest(userId: userId, roomId: String(roomId), passNum: passNum)
    }
    
    func attendanceRequest(userId: String, roomId: String, passNum: String) {
        let parameters = ["user_id": userId, "room_id": roomId, "pass_num": passNum]
        
        networkingService.request(endpoint: "/room/attendance/check", method: "PUT", parameters: parameters, completion: { [weak self] (result) in
            
            print(result)
            switch result {
                
            case .success:
                self?.view.addSubview(self!.blurEffectView)
                
            case .failure(let error):
                // did not enter any room yet
                print("pass num creation error", error)

            }
            self?.dismiss(animated: true, completion: nil)
        })
    }

}
