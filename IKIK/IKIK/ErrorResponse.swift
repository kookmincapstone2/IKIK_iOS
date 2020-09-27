//
//  ErrorResponse.swift
//  IKIK
//
//  Created by 서민주 on 2020/09/27.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, LocalizedError {
    let reason: String
    
    var errorDescription: String? { return reason }
}
