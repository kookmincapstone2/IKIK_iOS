//
//  User.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import Foundation

struct User: Decodable {
    let userId: Int
    let name: String
    let email: String?
    let pw: String?
    let studentId: Int?
    let tel: String?
    let rank: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case studentId = "student_id"
        case name, email, pw, tel, rank
    }
}
