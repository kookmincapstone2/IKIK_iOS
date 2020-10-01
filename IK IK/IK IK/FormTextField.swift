//
//  FormTextField.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import UIKit

class FormTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor : UIColor.systemGray2])
        
        self.layer.cornerRadius = 15.0
        self.backgroundColor = .systemGray6
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        self.leftView = leftView
        self.leftViewMode = .always
        
        
//        let underlineView = UIView()
//        underlineView.translatesAutoresizingMaskIntoConstraints = false
//        underlineView.backgroundColor = .white
//
//        addSubview(underlineView)
//
//        NSLayoutConstraint.activate([
//
//            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
//            underlineView.heightAnchor.constraint(equalToConstant: 1)
//            ])
    }
    
}
