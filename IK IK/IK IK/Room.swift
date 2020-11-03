//
//  Room.swift
//  IK IK
//
//  Created by 서민주 on 2020/10/15.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import Foundation

struct Room: Codable {
    let userId: Int?
    let roomId: Int
    let masterId: Int?
    let title: String
    let inviteCode: String?
    let maximumPopulation: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case roomId = "room_id"
        case masterId = "master_id"
        case title
        case inviteCode = "invite_code"
        case maximumPopulation = "maximum_population"
    }
}
