//
//  pinAuthResponse.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct validatePinResp : Codable {
    let rc : String?
    let desc : String?
    let tranId : String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "rc"
        case desc = "desc"
        case tranId = "tranId"
    }
}
