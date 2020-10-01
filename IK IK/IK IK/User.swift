//
//  User.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let email: String?
    let pw: String?
    let std_id: Int?
    let tel: String?
}
